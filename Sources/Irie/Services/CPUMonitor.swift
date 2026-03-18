import Foundation
import Darwin

final class CPUMonitor {
    private var previousTicks: [(user: UInt64, system: UInt64, idle: UInt64, nice: UInt64)] = []

    func sample() -> CPUUsage? {
        var processorCount: natural_t = 0
        var processorInfo: processor_info_array_t?
        var processorInfoCount: mach_msg_type_number_t = 0

        let result = host_processor_info(
            mach_host_self(),
            PROCESSOR_CPU_LOAD_INFO,
            &processorCount,
            &processorInfo,
            &processorInfoCount
        )

        guard result == KERN_SUCCESS, let info = processorInfo else {
            return nil
        }

        defer {
            vm_deallocate(
                mach_task_self_,
                vm_address_t(bitPattern: info),
                vm_size_t(Int(processorInfoCount) * MemoryLayout<Int32>.size)
            )
        }

        let cpuCount = Int(processorCount)
        var currentTicks: [(user: UInt64, system: UInt64, idle: UInt64, nice: UInt64)] = []

        for i in 0..<cpuCount {
            let offset = Int32(CPU_STATE_MAX) * Int32(i)
            let user = UInt64(info[Int(offset + CPU_STATE_USER)])
            let system = UInt64(info[Int(offset + CPU_STATE_SYSTEM)])
            let idle = UInt64(info[Int(offset + CPU_STATE_IDLE)])
            let nice = UInt64(info[Int(offset + CPU_STATE_NICE)])
            currentTicks.append((user: user, system: system, idle: idle, nice: nice))
        }

        guard !previousTicks.isEmpty, previousTicks.count == cpuCount else {
            previousTicks = currentTicks
            return nil
        }

        var perCore: [Double] = []
        var totalUsed: UInt64 = 0
        var totalAll: UInt64 = 0

        for i in 0..<cpuCount {
            let prev = previousTicks[i]
            let curr = currentTicks[i]

            let userDelta = curr.user - prev.user
            let systemDelta = curr.system - prev.system
            let idleDelta = curr.idle - prev.idle
            let niceDelta = curr.nice - prev.nice

            let used = userDelta + systemDelta + niceDelta
            let total = used + idleDelta

            let corePct = total > 0 ? Double(used) / Double(total) : 0
            perCore.append(corePct)

            totalUsed += used
            totalAll += total
        }

        previousTicks = currentTicks

        let overall = totalAll > 0 ? Double(totalUsed) / Double(totalAll) : 0
        return CPUUsage(overall: overall, perCore: perCore)
    }
}
