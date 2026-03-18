import SwiftUI

struct ProcessListView: View {
    let processes: [ProcessStat]
    @State private var sortOrder: SortField = .cpu

    enum SortField {
        case name, cpu, memory, threads
    }

    private var sortedProcesses: [ProcessStat] {
        switch sortOrder {
        case .name:
            return processes.sorted { $0.name.localizedCaseInsensitiveCompare($1.name) == .orderedAscending }
        case .cpu:
            return processes.sorted { $0.cpuUsage > $1.cpuUsage }
        case .memory:
            return processes.sorted { $0.memoryBytes > $1.memoryBytes }
        case .threads:
            return processes.sorted { $0.threadCount > $1.threadCount }
        }
    }

    var body: some View {
        VStack(alignment: .leading, spacing: 0) {
            // Column headers
            HStack(spacing: 0) {
                columnHeader("Process", field: .name, width: 180, alignment: .leading)
                columnHeader("CPU", field: .cpu, width: 70, alignment: .trailing)
                columnHeader("Memory", field: .memory, width: 90, alignment: .trailing)
                columnHeader("Threads", field: .threads, width: 60, alignment: .trailing)
            }
            .padding(.horizontal, DesignTokens.Spacing.sm)
            .padding(.vertical, DesignTokens.Spacing.xs)

            Divider()
                .overlay(DesignTokens.Colors.glassBorder)

            // Process rows
            ScrollView {
                LazyVStack(spacing: 0) {
                    ForEach(sortedProcesses) { proc in
                        ProcessRow(process: proc)
                    }
                }
            }
        }
    }

    private func columnHeader(_ title: String, field: SortField, width: CGFloat, alignment: Alignment) -> some View {
        Button {
            withAnimation(DesignTokens.Animation.quick) {
                sortOrder = field
            }
        } label: {
            HStack(spacing: 2) {
                Text(title)
                if sortOrder == field {
                    Image(systemName: "chevron.down")
                        .font(.system(size: 7, weight: .bold))
                }
            }
            .frame(width: width, alignment: alignment)
            .font(DesignTokens.Typography.caption)
            .foregroundStyle(
                sortOrder == field
                    ? DesignTokens.Colors.textPrimary
                    : DesignTokens.Colors.textTertiary
            )
        }
        .buttonStyle(.plain)
    }
}

// MARK: - Process Row

struct ProcessRow: View {
    let process: ProcessStat
    @State private var isHovered = false

    var body: some View {
        HStack(spacing: 0) {
            // Name
            Text(process.name)
                .font(DesignTokens.Typography.caption)
                .foregroundStyle(DesignTokens.Colors.textPrimary)
                .lineLimit(1)
                .truncationMode(.middle)
                .frame(width: 180, alignment: .leading)

            // CPU %
            Text(cpuText)
                .font(.system(size: 10, weight: .medium, design: .monospaced))
                .foregroundStyle(cpuColor)
                .frame(width: 70, alignment: .trailing)
                .contentTransition(.numericText())

            // Memory
            Text(FormatHelper.bytes(process.memoryBytes))
                .font(.system(size: 10, weight: .medium, design: .monospaced))
                .foregroundStyle(DesignTokens.Colors.textSecondary)
                .frame(width: 90, alignment: .trailing)
                .contentTransition(.numericText())

            // Threads
            Text("\(process.threadCount)")
                .font(.system(size: 10, weight: .medium, design: .monospaced))
                .foregroundStyle(DesignTokens.Colors.textTertiary)
                .frame(width: 60, alignment: .trailing)
        }
        .padding(.horizontal, DesignTokens.Spacing.sm)
        .padding(.vertical, DesignTokens.Spacing.xxs + 1)
        .background(
            RoundedRectangle(cornerRadius: 4)
                .fill(isHovered ? Color.white.opacity(0.04) : Color.clear)
        )
        .onHover { hovering in
            isHovered = hovering
        }
        .animation(DesignTokens.Animation.hover, value: isHovered)
    }

    private var cpuText: String {
        if process.cpuUsage < 0.1 {
            return "0%"
        }
        return String(format: "%.1f%%", process.cpuUsage)
    }

    private var cpuColor: Color {
        if process.cpuUsage > 80 {
            return DesignTokens.Colors.usageCritical
        } else if process.cpuUsage > 30 {
            return DesignTokens.Colors.usageWarning
        } else {
            return DesignTokens.Colors.textSecondary
        }
    }
}
