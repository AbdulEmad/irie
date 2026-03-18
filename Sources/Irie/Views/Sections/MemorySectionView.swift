import SwiftUI

struct MemorySectionView: View {
    let usage: MemoryUsage

    var body: some View {
        VStack(alignment: .leading, spacing: DesignTokens.Spacing.sm) {
            SectionHeader(title: "Memory")

            // Usage bar with label
            HStack(spacing: DesignTokens.Spacing.sm) {
                UsageBar(fraction: usage.fraction)
                Text("\(FormatHelper.bytes(usage.used)) / \(FormatHelper.bytes(usage.total))")
                    .font(DesignTokens.Typography.value)
                    .foregroundStyle(DesignTokens.Colors.textPrimary)
                    .lineLimit(1)
                    .fixedSize()
                    .contentTransition(.numericText())
            }

            // Breakdown
            HStack(spacing: DesignTokens.Spacing.lg) {
                StatRow(label: "Active", value: FormatHelper.bytes(usage.active))
                StatRow(label: "Wired", value: FormatHelper.bytes(usage.wired))
            }
            HStack(spacing: DesignTokens.Spacing.lg) {
                StatRow(label: "Compressed", value: FormatHelper.bytes(usage.compressed))
            }
        }
    }
}
