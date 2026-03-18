import SwiftUI

// MARK: - Hoverable Row Modifier

struct HoverableRowModifier: ViewModifier {
    @State private var isHovered = false

    func body(content: Content) -> some View {
        content
            .padding(.horizontal, DesignTokens.Spacing.sm)
            .padding(.vertical, DesignTokens.Spacing.xs)
            .background(
                RoundedRectangle(cornerRadius: DesignTokens.Dimensions.buttonRadius)
                    .fill(.ultraThinMaterial)
            )
            .overlay(
                RoundedRectangle(cornerRadius: DesignTokens.Dimensions.buttonRadius)
                    .fill(isHovered ? Color.white.opacity(0.04) : Color.clear)
                    .allowsHitTesting(false)
            )
            .overlay(
                RoundedRectangle(cornerRadius: DesignTokens.Dimensions.buttonRadius)
                    .stroke(DesignTokens.Colors.glassBorder, lineWidth: 0.5)
                    .allowsHitTesting(false)
            )
            .onHover { hovering in
                isHovered = hovering
            }
            .animation(DesignTokens.Animation.hover, value: isHovered)
    }
}

// MARK: - Hover Highlight Modifier

struct HoverHighlightModifier: ViewModifier {
    let cornerRadius: CGFloat
    @State private var isHovered = false

    func body(content: Content) -> some View {
        content
            .background(
                RoundedRectangle(cornerRadius: cornerRadius)
                    .fill(isHovered ? Color.white.opacity(0.04) : Color.clear)
            )
            .onHover { hovering in
                isHovered = hovering
            }
            .animation(DesignTokens.Animation.hover, value: isHovered)
    }
}

// MARK: - Hoverable Card Modifier

struct HoverableCardModifier: ViewModifier {
    let cornerRadius: CGFloat
    @State private var isHovered = false

    func body(content: Content) -> some View {
        content
            .background(
                RoundedRectangle(cornerRadius: cornerRadius)
                    .fill(.ultraThinMaterial)
            )
            .overlay(
                RoundedRectangle(cornerRadius: cornerRadius)
                    .fill(isHovered ? Color.white.opacity(0.04) : Color.clear)
            )
            .overlay(
                RoundedRectangle(cornerRadius: cornerRadius)
                    .stroke(
                        isHovered ? DesignTokens.Colors.glassBorderHover : DesignTokens.Colors.glassBorder,
                        lineWidth: 0.5
                    )
            )
            .onHover { hovering in
                isHovered = hovering
            }
            .animation(DesignTokens.Animation.hover, value: isHovered)
    }
}

// MARK: - Section Header Style Modifier

struct SectionHeaderStyleModifier: ViewModifier {
    func body(content: Content) -> some View {
        content
            .font(DesignTokens.Typography.sectionHeader)
            .foregroundStyle(DesignTokens.Colors.textTertiary)
            .tracking(DesignTokens.Typography.sectionHeaderTracking)
            .textCase(.uppercase)
    }
}

// MARK: - Glass Button Style Modifier

struct GlassButtonStyleModifier: ViewModifier {
    @State private var isHovered = false

    func body(content: Content) -> some View {
        content
            .padding(.horizontal, DesignTokens.Spacing.sm)
            .padding(.vertical, DesignTokens.Spacing.xs)
            .background {
                Capsule()
                    .fill(.ultraThinMaterial)
            }
            .overlay {
                Capsule()
                    .strokeBorder(
                        isHovered ? DesignTokens.Colors.glassBorderHover : DesignTokens.Colors.glassBorder,
                        lineWidth: 0.5
                    )
            }
            .scaleEffect(isHovered ? 1.02 : 1.0)
            .onHover { hovering in
                isHovered = hovering
            }
            .animation(DesignTokens.Animation.hover, value: isHovered)
    }
}

// MARK: - Vibrancy Icon Modifier

struct VibrancyIconModifier: ViewModifier {
    let style: VibrancyStyle

    enum VibrancyStyle {
        case primary, secondary, tertiary
    }

    func body(content: Content) -> some View {
        content
            .symbolRenderingMode(.hierarchical)
            .foregroundStyle(foregroundColor)
    }

    private var foregroundColor: Color {
        switch style {
        case .primary: return .primary
        case .secondary: return .secondary
        case .tertiary: return DesignTokens.Colors.textTertiary
        }
    }
}

// MARK: - View Extensions

extension View {
    func hoverableRow() -> some View {
        modifier(HoverableRowModifier())
    }

    func hoverHighlight(cornerRadius: CGFloat = DesignTokens.Dimensions.miniBarHeight) -> some View {
        modifier(HoverHighlightModifier(cornerRadius: cornerRadius))
    }

    func hoverableCard(cornerRadius: CGFloat = DesignTokens.Dimensions.rowRadius) -> some View {
        modifier(HoverableCardModifier(cornerRadius: cornerRadius))
    }

    func sectionHeaderStyle() -> some View {
        modifier(SectionHeaderStyleModifier())
    }

    func glassButtonStyle() -> some View {
        modifier(GlassButtonStyleModifier())
    }

    func vibrancyIcon(_ style: VibrancyIconModifier.VibrancyStyle = .secondary) -> some View {
        modifier(VibrancyIconModifier(style: style))
    }
}
