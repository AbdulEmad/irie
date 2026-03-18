import SwiftUI

/// A horizontal usage bar that fills proportionally
struct UsageBar: View {
    let fraction: Double
    var color: Color? = nil
    var height: CGFloat = DesignTokens.Dimensions.barHeight

    private var fillColor: Color {
        color ?? DesignTokens.Colors.usageColor(for: fraction)
    }

    var body: some View {
        GeometryReader { geo in
            ZStack(alignment: .leading) {
                Capsule()
                    .fill(DesignTokens.Colors.barBackground)

                Capsule()
                    .fill(fillColor)
                    .frame(width: max(0, geo.size.width * CGFloat(min(fraction, 1.0))))
            }
        }
        .frame(height: height)
        .animation(DesignTokens.Animation.value, value: fraction)
    }
}
