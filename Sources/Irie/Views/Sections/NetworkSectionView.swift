import SwiftUI

struct NetworkSectionView: View {
    let usage: NetworkUsage

    var body: some View {
        VStack(alignment: .leading, spacing: DesignTokens.Spacing.sm) {
            SectionHeader(title: "Network")

            HStack(spacing: DesignTokens.Spacing.xl) {
                HStack(spacing: DesignTokens.Spacing.xs) {
                    Image(systemName: "arrow.down")
                        .font(.system(size: 10, weight: .bold))
                        .foregroundStyle(DesignTokens.Colors.usageNormal)
                    Text(FormatHelper.rate(usage.bytesInPerSec))
                        .font(DesignTokens.Typography.value)
                        .foregroundStyle(DesignTokens.Colors.textPrimary)
                        .contentTransition(.numericText())
                }

                HStack(spacing: DesignTokens.Spacing.xs) {
                    Image(systemName: "arrow.up")
                        .font(.system(size: 10, weight: .bold))
                        .foregroundStyle(DesignTokens.Colors.usageWarning)
                    Text(FormatHelper.rate(usage.bytesOutPerSec))
                        .font(DesignTokens.Typography.value)
                        .foregroundStyle(DesignTokens.Colors.textPrimary)
                        .contentTransition(.numericText())
                }

                Spacer()
            }
        }
    }
}
