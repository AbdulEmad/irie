import SwiftUI
import AppKit

/// A dark frosted glass background using NSVisualEffectView
struct VisualEffectBackground: NSViewRepresentable {
    var material: NSVisualEffectView.Material = .hudWindow
    var blendingMode: NSVisualEffectView.BlendingMode = .behindWindow

    func makeNSView(context: Context) -> NSVisualEffectView {
        let view = NSVisualEffectView()
        view.material = material
        view.blendingMode = blendingMode
        view.state = .active
        view.appearance = NSAppearance(named: .darkAqua)
        return view
    }

    func updateNSView(_ nsView: NSVisualEffectView, context: Context) {
        nsView.material = material
        nsView.blendingMode = blendingMode
    }
}

// MARK: - View Extensions

extension Color {
    static var popupBackgroundOverlay: Color { DesignTokens.Colors.popupOverlay }
}

extension View {
    func darkGlassBackground() -> some View {
        self
            .background(Color.popupBackgroundOverlay)
            .background(VisualEffectBackground(material: .hudWindow, blendingMode: .behindWindow))
    }
}
