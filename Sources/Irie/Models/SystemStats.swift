import Foundation

struct CPUUsage: Equatable {
    let overall: Double           // 0–1
    let perCore: [Double]         // 0–1 per core
}

struct MemoryUsage: Equatable {
    let total: UInt64             // bytes
    let active: UInt64
    let wired: UInt64
    let compressed: UInt64
    let inactive: UInt64
    let free: UInt64

    var used: UInt64 { active + wired + compressed }
    var fraction: Double { total > 0 ? Double(used) / Double(total) : 0 }
}

struct DiskUsage: Equatable {
    let total: Int64              // bytes
    let free: Int64

    var used: Int64 { total - free }
    var fraction: Double { total > 0 ? Double(used) / Double(total) : 0 }
}

struct NetworkUsage: Equatable {
    let bytesInPerSec: Double
    let bytesOutPerSec: Double
}

// MARK: - Formatting Helpers

enum FormatHelper {
    static func bytes(_ value: UInt64) -> String {
        ByteCountFormatter.string(fromByteCount: Int64(value), countStyle: .memory)
    }

    static func bytes(_ value: Int64) -> String {
        ByteCountFormatter.string(fromByteCount: value, countStyle: .memory)
    }

    static func rate(_ bytesPerSec: Double) -> String {
        if bytesPerSec < 1024 {
            return String(format: "%.0f B/s", bytesPerSec)
        } else if bytesPerSec < 1024 * 1024 {
            return String(format: "%.1f KB/s", bytesPerSec / 1024)
        } else {
            return String(format: "%.1f MB/s", bytesPerSec / (1024 * 1024))
        }
    }

    static func percent(_ fraction: Double) -> String {
        String(format: "%.0f%%", fraction * 100)
    }
}
