import SwiftUI

@main
struct VitalsApp: App {
    @State private var systemMonitor = SystemMonitor()

    init() {
        // Hide dock icon (equivalent to LSUIElement = true)
        NSApplication.shared.setActivationPolicy(.accessory)
    }

    var body: some Scene {
        MenuBarExtra {
            MenuBarPopupView(systemMonitor: systemMonitor)
                .frame(width: DesignTokens.Dimensions.popupWidth)
        } label: {
            Image(systemName: "gauge.medium")
        }
        .menuBarExtraStyle(.window)
    }
}
