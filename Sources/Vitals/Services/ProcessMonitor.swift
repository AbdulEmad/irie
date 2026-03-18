import Foundation
import Darwin

final class ProcessMonitor {
    /// Previous CPU time snapshots keyed by PID
    private var previousCPUTimes: [pid_t: (user: UInt64, system: UInt64, timestamp: Date)] = [:]

    func sample() -> [ProcessStat] {
        // Get all PIDs
        let bufferSize = proc_listallpids(nil, 0)
        guard bufferSize > 0 else { return [] }

        var pids = [pid_t](repeating: 0, count: Int(bufferSize))
        let actualCount = proc_listallpids(&pids, Int32(MemoryLayout<pid_t>.size * pids.count))
        guard actualCount > 0 else { return [] }

        let now = Date()
        var results: [ProcessStat] = []
        var seenPids = Set<pid_t>()

        for i in 0..<Int(actualCount) {
            let pid = pids[i]
            guard pid > 0 else { continue }
            seenPids.insert(pid)

            // Get task info
            var taskInfo = proc_taskinfo()
            let size = Int32(MemoryLayout<proc_taskinfo>.size)
            let ret = proc_pidinfo(pid, PROC_PIDTASKINFO, 0, &taskInfo, size)
            guard ret == size else { continue }

            // Get process name
            var nameBuffer = [CChar](repeating: 0, count: 4 * Int(MAXPATHLEN))
            proc_pidpath(pid, &nameBuffer, UInt32(nameBuffer.count))
            let fullPath = String(cString: nameBuffer)
            let name = (fullPath as NSString).lastPathComponent
            guard !name.isEmpty else { continue }

            // Calculate CPU usage from delta
            let userTime = taskInfo.pti_total_user
            let systemTime = taskInfo.pti_total_system
            var cpuUsage = 0.0

            if let prev = previousCPUTimes[pid] {
                let elapsed = now.timeIntervalSince(prev.timestamp)
                if elapsed > 0 {
                    let userDelta = userTime - prev.user
                    let systemDelta = systemTime - prev.system
                    // Times are in nanoseconds
                    let totalCPUSeconds = Double(userDelta + systemDelta) / 1_000_000_000
                    cpuUsage = (totalCPUSeconds / elapsed) * 100
                }
            }

            previousCPUTimes[pid] = (user: userTime, system: systemTime, timestamp: now)

            let memoryBytes = UInt64(taskInfo.pti_resident_size)

            results.append(ProcessStat(
                id: pid,
                name: name,
                cpuUsage: cpuUsage,
                memoryBytes: memoryBytes,
                threadCount: taskInfo.pti_threadnum
            ))
        }

        // Prune stale PIDs
        previousCPUTimes = previousCPUTimes.filter { seenPids.contains($0.key) }

        // Sort by CPU descending, then memory descending
        results.sort { a, b in
            if abs(a.cpuUsage - b.cpuUsage) > 0.1 {
                return a.cpuUsage > b.cpuUsage
            }
            return a.memoryBytes > b.memoryBytes
        }

        return results
    }
}
