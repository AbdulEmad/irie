import Foundation
import Darwin

final class NetworkMonitor {
    private var previousBytesIn: UInt64 = 0
    private var previousBytesOut: UInt64 = 0
    private var previousTime: Date?

    func sample() -> NetworkUsage? {
        let (bytesIn, bytesOut) = currentTotalBytes()

        guard let prevTime = previousTime else {
            previousBytesIn = bytesIn
            previousBytesOut = bytesOut
            previousTime = Date()
            return nil
        }

        let now = Date()
        let elapsed = now.timeIntervalSince(prevTime)

        guard elapsed > 0 else { return nil }

        let inRate = Double(bytesIn - previousBytesIn) / elapsed
        let outRate = Double(bytesOut - previousBytesOut) / elapsed

        previousBytesIn = bytesIn
        previousBytesOut = bytesOut
        previousTime = now

        return NetworkUsage(
            bytesInPerSec: max(0, inRate),
            bytesOutPerSec: max(0, outRate)
        )
    }

    private func currentTotalBytes() -> (bytesIn: UInt64, bytesOut: UInt64) {
        var ifaddrPtr: UnsafeMutablePointer<ifaddrs>?
        guard getifaddrs(&ifaddrPtr) == 0, let firstAddr = ifaddrPtr else {
            return (0, 0)
        }
        defer { freeifaddrs(ifaddrPtr) }

        var totalIn: UInt64 = 0
        var totalOut: UInt64 = 0

        var cursor: UnsafeMutablePointer<ifaddrs>? = firstAddr
        while let addr = cursor {
            let ifa = addr.pointee

            // Only look at AF_LINK (link-layer) entries
            if ifa.ifa_addr?.pointee.sa_family == UInt8(AF_LINK) {
                // Skip loopback
                let name = String(cString: ifa.ifa_name)
                if name != "lo0", let data = ifa.ifa_data {
                    let networkData = data.assumingMemoryBound(to: if_data.self).pointee
                    totalIn += UInt64(networkData.ifi_ibytes)
                    totalOut += UInt64(networkData.ifi_obytes)
                }
            }
            cursor = ifa.ifa_next
        }

        return (totalIn, totalOut)
    }
}
