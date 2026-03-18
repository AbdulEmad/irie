import Foundation
import Combine

@Observable
final class SystemMonitor {
    var cpu: CPUUsage = CPUUsage(overall: 0, perCore: [])
    var memory: MemoryUsage = MemoryUsage(total: 0, active: 0, wired: 0, compressed: 0, inactive: 0, free: 0)
    var disk: DiskUsage = DiskUsage(total: 0, free: 0)
    var network: NetworkUsage = NetworkUsage(bytesInPerSec: 0, bytesOutPerSec: 0)
    var processes: [ProcessStat] = []

    private let cpuMonitor = CPUMonitor()
    private let networkMonitor = NetworkMonitor()
    private let processMonitor = ProcessMonitor()
    private var timer: Timer?

    init() {
        // Take an initial sample so first real sample has a delta
        _ = cpuMonitor.sample()
        _ = networkMonitor.sample()
        _ = processMonitor.sample()

        startMonitoring()
    }

    deinit {
        timer?.invalidate()
    }

    private func startMonitoring() {
        timer = Timer.scheduledTimer(withTimeInterval: 2.0, repeats: true) { [weak self] _ in
            Task { @MainActor in
                self?.refresh()
            }
        }
        // Also refresh immediately after a short delay for first data
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) { [weak self] in
            Task { @MainActor in
                self?.refresh()
            }
        }
    }

    @MainActor
    private func refresh() {
        if let cpuData = cpuMonitor.sample() {
            cpu = cpuData
        }
        if let memData = MemoryMonitor.sample() {
            memory = memData
        }
        if let diskData = DiskMonitor.sample() {
            disk = diskData
        }
        if let netData = networkMonitor.sample() {
            network = netData
        }
        processes = processMonitor.sample()
    }
}
