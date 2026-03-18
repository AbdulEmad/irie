import SwiftUI

struct CPUSectionView: View {
    let usage: CPUUsage

    var body: some View {
        VStack(alignment: .leading, spacing: DesignTokens.Spacing.sm) {
            SectionHeader(title: "CPU")

            // Overall usage bar
            HStack(spacing: DesignTokens.Spacing.sm) {
                UsageBar(fraction: usage.overall)
                Text(FormatHelper.percent(usage.overall))
                    .font(DesignTokens.Typography.value)
                    .foregroundStyle(DesignTokens.Colors.textPrimary)
                    .frame(width: 40, alignment: .trailing)
                    .contentTransition(.numericText())
            }

            // Per-core mini bars
            if !usage.perCore.isEmpty {
                let columns = min(usage.perCore.count, 4)
                let rows = (usage.perCore.count + columns - 1) / columns

                VStack(spacing: DesignTokens.Spacing.xs) {
                    ForEach(0..<rows, id: \.self) { row in
                        HStack(spacing: DesignTokens.Spacing.sm) {
                            ForEach(0..<columns, id: \.self) { col in
                                let index = row * columns + col
                                if index < usage.perCore.count {
                                    coreBar(index: index, value: usage.perCore[index])
                                }
                            }
                        }
                    }
                }
            }
        }
    }

    private func coreBar(index: Int, value: Double) -> some View {
        HStack(spacing: DesignTokens.Spacing.xs) {
            Text("\(index + 1)")
                .font(DesignTokens.Typography.caption)
                .foregroundStyle(DesignTokens.Colors.textTertiary)
                .frame(width: 14, alignment: .trailing)
            UsageBar(fraction: value, height: DesignTokens.Dimensions.miniBarHeight)
            Text(FormatHelper.percent(value))
                .font(.system(size: 9, weight: .medium, design: .monospaced))
                .foregroundStyle(DesignTokens.Colors.textSecondary)
                .frame(width: 30, alignment: .trailing)
                .contentTransition(.numericText())
        }
    }
}
