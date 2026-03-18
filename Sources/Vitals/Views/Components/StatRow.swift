import SwiftUI

/// A label + value row for displaying a single stat
struct StatRow: View {
    let label: String
    let value: String

    var body: some View {
        HStack {
            Text(label)
                .font(DesignTokens.Typography.caption)
                .foregroundStyle(DesignTokens.Colors.textSecondary)
            Spacer()
            Text(value)
                .font(DesignTokens.Typography.value)
                .foregroundStyle(DesignTokens.Colors.textPrimary)
                .contentTransition(.numericText())
        }
    }
}
