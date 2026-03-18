import Foundation

struct ProcessStat: Identifiable, Equatable {
    let id: pid_t           // PID
    let name: String
    let cpuUsage: Double    // percentage (0–100+)
    let memoryBytes: UInt64
    let threadCount: Int32
}
