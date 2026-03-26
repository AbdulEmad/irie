import ServiceManagement
import SwiftUI

struct SettingsView: View {
    var dismiss: () -> Void
    @State private var launchAtLogin = SMAppService.mainApp.status == .enabled

    var body: some View {
        VStack(alignment: .leading, spacing: 0) {
            // Header
            HStack {
                Button {
                    withAnimation(DesignTokens.Animation.quick) {
                        dismiss()
                    }
                } label: {
                    HStack(spacing: DesignTokens.Spacing.xs) {
                        Image(systemName: "chevron.left")
                            .font(.system(size: 9, weight: .semibold))
                        Text("Settings")
                            .font(.system(size: 10, weight: .medium))
                    }
                    .foregroundStyle(DesignTokens.Colors.textPrimary)
                }
                .buttonStyle(.plain)
                .glassButtonStyle()

                Spacer()
            }
            .padding(.horizontal, DesignTokens.Spacing.lg)
            .padding(.top, DesignTokens.Spacing.lg)
            .padding(.bottom, DesignTokens.Spacing.md)

            Divider()
                .overlay(DesignTokens.Colors.glassBorder)

            // Settings content
            VStack(alignment: .leading, spacing: DesignTokens.Spacing.md) {
                Toggle(isOn: $launchAtLogin) {
                    HStack(spacing: DesignTokens.Spacing.sm) {
                        Image(systemName: "arrow.right.circle")
                            .font(.system(size: 12))
                            .foregroundStyle(DesignTokens.Colors.textSecondary)
                        VStack(alignment: .leading, spacing: 2) {
                            Text("Launch at Login")
                                .font(DesignTokens.Typography.rowName)
                                .foregroundStyle(DesignTokens.Colors.textPrimary)
                            Text("Automatically start Irie when you log in")
                                .font(DesignTokens.Typography.caption)
                                .foregroundStyle(DesignTokens.Colors.textTertiary)
                        }
                    }
                }
                .toggleStyle(.switch)
                .tint(.white.opacity(0.5))
                .onChange(of: launchAtLogin) { _, newValue in
                    do {
                        if newValue {
                            try SMAppService.mainApp.register()
                        } else {
                            try SMAppService.mainApp.unregister()
                        }
                    } catch {
                        launchAtLogin = SMAppService.mainApp.status == .enabled
                    }
                }
            }
            .padding(DesignTokens.Spacing.lg)

            Spacer()
        }
    }
}
