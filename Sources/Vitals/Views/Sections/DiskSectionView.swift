import SwiftUI

struct DiskSectionView: View {
    let usage: DiskUsage

    var body: some View {
        VStack(alignment: .leading, spacing: DesignTokens.Spacing.sm) {
            SectionHeader(title: "Disk")

            HStack(spacing: DesignTokens.Spacing.sm) {
                UsageBar(fraction: usage.fraction)
                Text("\(FormatHelper.bytes(usage.used)) / \(FormatHelper.bytes(usage.total))")
                    .font(DesignTokens.Typography.value)
                    .foregroundStyle(DesignTokens.Colors.textPrimary)
                    .lineLimit(1)
                    .fixedSize()
                    .contentTransition(.numericText())
            }
        }
    }
}
