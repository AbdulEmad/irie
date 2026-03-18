import SwiftUI

enum StatCategory: String, CaseIterable, Identifiable {
    case cpu = "CPU"
    case memory = "Memory"
    case disk = "Disk"
    case network = "Network"

    var id: String { rawValue }

    var icon: String {
        switch self {
        case .cpu: return "cpu"
        case .memory: return "memorychip"
        case .disk: return "internaldrive"
        case .network: return "network"
        }
    }
}

struct StatsGridView: View {
    let systemMonitor: SystemMonitor
    @Binding var expandedCategory: StatCategory?

    var body: some View {
        VStack(spacing: 0) {
            if let category = expandedCategory {
                expandedView(for: category)
            } else {
                gridView
            }
        }
        .animation(DesignTokens.Animation.quick, value: expandedCategory)
    }

    // MARK: - Grid View

    private var gridView: some View {
        VStack(spacing: DesignTokens.Spacing.sm) {
            HStack(spacing: DesignTokens.Spacing.sm) {
                StatCardView(
                    category: .cpu,
                    headline: FormatHelper.percent(systemMonitor.cpu.overall),
                    fraction: systemMonitor.cpu.overall
                ) { expandedCategory = .cpu }

                StatCardView(
                    category: .memory,
                    headline: FormatHelper.percent(systemMonitor.memory.fraction),
                    fraction: systemMonitor.memory.fraction,
                    subtitle: "\(FormatHelper.bytes(systemMonitor.memory.used)) / \(FormatHelper.bytes(systemMonitor.memory.total))"
                ) { expandedCategory = .memory }
            }

            HStack(spacing: DesignTokens.Spacing.sm) {
                StatCardView(
                    category: .disk,
                    headline: FormatHelper.percent(systemMonitor.disk.fraction),
                    fraction: systemMonitor.disk.fraction,
                    subtitle: "\(FormatHelper.bytes(systemMonitor.disk.used)) / \(FormatHelper.bytes(systemMonitor.disk.total))"
                ) { expandedCategory = .disk }

                StatCardView(
                    category: .network,
                    headline: FormatHelper.rate(systemMonitor.network.bytesInPerSec),
                    fraction: nil,
                    subtitle: "↑ \(FormatHelper.rate(systemMonitor.network.bytesOutPerSec))"
                ) { expandedCategory = .network }
            }
        }
        .padding(DesignTokens.Spacing.lg)
    }

    // MARK: - Expanded Detail View

    private func expandedView(for category: StatCategory) -> some View {
        VStack(alignment: .leading, spacing: 0) {
            // Back button header
            Button {
                expandedCategory = nil
            } label: {
                HStack(spacing: DesignTokens.Spacing.xs) {
                    Image(systemName: "chevron.left")
                        .font(.system(size: 10, weight: .semibold))
                    Text(category.rawValue)
                        .font(DesignTokens.Typography.rowNameBold)
                }
                .foregroundStyle(DesignTokens.Colors.textSecondary)
            }
            .buttonStyle(.plain)
            .padding(.horizontal, DesignTokens.Spacing.lg)
            .padding(.top, DesignTokens.Spacing.md)
            .padding(.bottom, DesignTokens.Spacing.sm)

            Divider()
                .overlay(DesignTokens.Colors.glassBorder)

            ScrollView {
                VStack(alignment: .leading, spacing: DesignTokens.Spacing.lg) {
                    switch category {
                    case .cpu:
                        CPUSectionView(usage: systemMonitor.cpu)
                    case .memory:
                        MemorySectionView(usage: systemMonitor.memory)
                    case .disk:
                        DiskSectionView(usage: systemMonitor.disk)
                    case .network:
                        NetworkSectionView(usage: systemMonitor.network)
                    }
                }
                .padding(DesignTokens.Spacing.lg)
            }
            .frame(maxHeight: DesignTokens.Dimensions.maxScrollHeight - 40)
        }
    }
}

// MARK: - Stat Card View

struct StatCardView: View {
    let category: StatCategory
    let headline: String
    let fraction: Double?
    var subtitle: String? = nil
    let onTap: () -> Void

    var body: some View {
        Button(action: onTap) {
            VStack(alignment: .leading, spacing: DesignTokens.Spacing.sm) {
                // Icon + Title row
                HStack(spacing: DesignTokens.Spacing.xs) {
                    Image(systemName: category.icon)
                        .font(.system(size: 11, weight: .medium))
                        .foregroundStyle(iconColor)
                    Text(category.rawValue)
                        .font(DesignTokens.Typography.caption)
                        .foregroundStyle(DesignTokens.Colors.textTertiary)
                        .textCase(.uppercase)
                        .tracking(0.8)
                    Spacer()
                }

                // Primary metric
                Text(headline)
                    .font(DesignTokens.Typography.headline)
                    .foregroundStyle(DesignTokens.Colors.textPrimary)
                    .contentTransition(.numericText())
                    .lineLimit(1)
                    .minimumScaleFactor(0.7)

                // Usage bar or subtitle
                if let fraction = fraction {
                    UsageBar(fraction: fraction, height: DesignTokens.Dimensions.miniBarHeight)
                }

                if let subtitle = subtitle {
                    Text(subtitle)
                        .font(DesignTokens.Typography.captionSmall)
                        .foregroundStyle(DesignTokens.Colors.textSecondary)
                        .lineLimit(1)
                        .contentTransition(.numericText())
                } else {
                    // Spacer to keep cards same height when no subtitle
                    Text(" ")
                        .font(.system(size: 9))
                }
            }
            .padding(DesignTokens.Spacing.md)
            .frame(maxWidth: .infinity, alignment: .leading)
            .hoverableCard()
        }
        .buttonStyle(.plain)
    }

    private var iconColor: Color {
        guard let fraction = fraction else {
            return DesignTokens.Colors.usageNormal
        }
        return DesignTokens.Colors.usageColor(for: fraction)
    }
}
