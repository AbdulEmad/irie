import Foundation

enum DiskMonitor {
    static func sample() -> DiskUsage? {
        guard let attrs = try? FileManager.default.attributesOfFileSystem(forPath: "/"),
              let totalSize = attrs[.systemSize] as? Int64,
              let freeSize = attrs[.systemFreeSize] as? Int64
        else {
            return nil
        }

        return DiskUsage(total: totalSize, free: freeSize)
    }
}
