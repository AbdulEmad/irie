import SwiftUI

/// Design System tokens for Irie UI — adapted from FineTune
enum DesignTokens {

    // MARK: - Colors

    enum Colors {
        // MARK: Text (Vibrancy-aware)
        static let textPrimary: Color = .primary
        static let textSecondary: Color = .secondary
        static let textTertiary = Color(nsColor: .tertiaryLabelColor)
        static let textQuaternary = Color(nsColor: .quaternaryLabelColor)

        // MARK: Interactive
        static let interactiveDefault: Color = .primary.opacity(0.7)
        static let interactiveHover: Color = .primary.opacity(0.9)
        static let interactiveActive: Color = .primary

        // MARK: Separators & Borders
        static let separator = Color(nsColor: .separatorColor)
        static let glassBorder = Color(nsColor: .separatorColor).opacity(0.3)
        static let glassBorderHover = Color(nsColor: .separatorColor).opacity(0.5)

        // MARK: Glass Effects
        static let popupOverlay: Color = .black.opacity(0.4)
        static let recessedBackground: Color = .black.opacity(0.3)

        // MARK: Stat Usage Colors (green → yellow → red)
        static let usageNormal = Color(red: 0.20, green: 0.78, blue: 0.40)
        static let usageWarning = Color(red: 0.95, green: 0.75, blue: 0.20)
        static let usageCritical = Color(red: 0.90, green: 0.25, blue: 0.25)

        // MARK: Bar backgrounds
        static let barBackground: Color = .primary.opacity(0.12)

        /// Returns an appropriate color for a usage percentage (0–1)
        static func usageColor(for fraction: Double) -> Color {
            if fraction < 0.6 {
                return usageNormal
            } else if fraction < 0.85 {
                return usageWarning
            } else {
                return usageCritical
            }
        }
    }

    // MARK: - Typography

    enum Typography {
        static let sectionHeader = Font.system(size: 12, weight: .bold)
        static let sectionHeaderTracking: CGFloat = 1.2

        static let rowName = Font.system(size: 13, weight: .regular)
        static let rowNameBold = Font.system(size: 13, weight: .semibold)

        static let value = Font.system(size: 11, weight: .medium, design: .monospaced)
        static let caption = Font.system(size: 10, weight: .regular)
        static let captionSmall = Font.system(size: 9, weight: .medium, design: .monospaced)

        static let headline = Font.system(size: 20, weight: .semibold, design: .monospaced)
        static let title = Font.system(size: 14, weight: .bold)
    }

    // MARK: - Spacing

    enum Spacing {
        static let xxs: CGFloat = 2
        static let xs: CGFloat = 4
        static let sm: CGFloat = 8
        static let md: CGFloat = 12
        static let lg: CGFloat = 16
        static let xl: CGFloat = 20
        static let xxl: CGFloat = 24
    }

    // MARK: - Dimensions

    enum Dimensions {
        static let popupWidth: CGFloat = 480
        static var contentPadding: CGFloat { Spacing.lg }
        static var contentWidth: CGFloat { popupWidth - (contentPadding * 2) }

        static let maxScrollHeight: CGFloat = 500
        static let cornerRadius: CGFloat = 12
        static let rowRadius: CGFloat = 10
        static let buttonRadius: CGFloat = 6

        static let barHeight: CGFloat = 8
        static let miniBarHeight: CGFloat = 4
        static let iconSize: CGFloat = 22
        static let iconSizeSmall: CGFloat = 14
        static let minTouchTarget: CGFloat = 16
        static let maxGridColumns: Int = 4
    }

    // MARK: - Animation

    enum Animation {
        static let quick = SwiftUI.Animation.spring(response: 0.2, dampingFraction: 0.85)
        static let hover = SwiftUI.Animation.easeOut(duration: 0.12)
        static let value = SwiftUI.Animation.easeInOut(duration: 0.3)
    }
}
