import SwiftUI
import AppKit

struct ProcessListView: View {
    let processes: [ProcessStat]
    @State private var sortOrder: SortField = .cpu
    @State private var ascending: Bool = false

    enum SortField {
        case name, cpu, memory, threads
    }

    private var sortedProcesses: [ProcessStat] {
        let sorted: [ProcessStat]
        switch sortOrder {
        case .name:
            sorted = processes.sorted { $0.name.localizedCaseInsensitiveCompare($1.name) == .orderedAscending }
        case .cpu:
            sorted = processes.sorted { $0.cpuUsage > $1.cpuUsage }
        case .memory:
            sorted = processes.sorted { $0.memoryBytes > $1.memoryBytes }
        case .threads:
            sorted = processes.sorted { $0.threadCount > $1.threadCount }
        }
        return ascending ? sorted.reversed() : sorted
    }

    var body: some View {
        VStack(alignment: .leading, spacing: 0) {
            // Column headers — matches row layout exactly
            HStack(spacing: 0) {
                Text("")
                    .frame(width: 22)

                columnHeader("Process", field: .name, width: 158, alignment: .leading)
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
                    ForEach(Array(sortedProcesses.enumerated()), id: \.element.id) { index, proc in
                        ProcessRow(process: proc, isAlternate: index.isMultiple(of: 2))
                    }
                }
            }
        }
    }

    private func columnHeader(_ title: String, field: SortField, width: CGFloat, alignment: Alignment) -> some View {
        Button {
            withAnimation(DesignTokens.Animation.quick) {
                if sortOrder == field {
                    ascending.toggle()
                } else {
                    sortOrder = field
                    ascending = false
                }
            }
        } label: {
            HStack(spacing: 2) {
                Text(title)
                if sortOrder == field {
                    Image(systemName: "chevron.down")
                        .font(.system(size: 7, weight: .bold))
                        .rotationEffect(.degrees(ascending ? 180 : 0))
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
    let isAlternate: Bool

    var body: some View {
        HStack(spacing: 0) {
            // App icon
            ProcessIconView(path: process.path)
                .frame(width: 22)

            // Name
            Text(process.name)
                .font(DesignTokens.Typography.caption)
                .foregroundStyle(DesignTokens.Colors.textPrimary)
                .lineLimit(1)
                .truncationMode(.middle)
                .frame(width: 158, alignment: .leading)

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
        .background(isAlternate ? Color.white.opacity(0.02) : Color.clear)
        .hoverHighlight()
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

// MARK: - Process Icon

struct ProcessIconView: View {
    let path: String

    var body: some View {
        Image(nsImage: appIcon)
            .resizable()
            .aspectRatio(contentMode: .fit)
            .frame(width: 14, height: 14)
    }

    private var appIcon: NSImage {
        // Try to find the .app bundle by walking up from the executable path
        var url = URL(fileURLWithPath: path)
        for _ in 0..<5 {
            url = url.deletingLastPathComponent()
            if url.pathExtension == "app" {
                let icon = NSWorkspace.shared.icon(forFile: url.path)
                icon.size = NSSize(width: 14, height: 14)
                return icon
            }
        }
        // Fallback: generic executable icon
        return NSWorkspace.shared.icon(forFile: path)
    }
}
