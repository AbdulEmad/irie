import SwiftUI

enum IrieTab: String, CaseIterable {
    case stats = "Stats"
    case tasks = "Tasks"

    var icon: String {
        switch self {
        case .stats: return "gauge.medium"
        case .tasks: return "list.bullet.rectangle"
        }
    }
}

struct MenuBarPopupView: View {
    let systemMonitor: SystemMonitor
    @State private var selectedTab: IrieTab = .stats
    @State private var expandedCategory: StatCategory? = nil

    var body: some View {
        VStack(alignment: .leading, spacing: 0) {
            // Header
            HStack {
                tabBar

                Spacer()

                Button {
                    NSApplication.shared.terminate(nil)
                } label: {
                    Text("Quit")
                        .font(DesignTokens.Typography.caption)
                        .foregroundStyle(DesignTokens.Colors.textSecondary)
                }
                .buttonStyle(.plain)
                .glassButtonStyle()
            }
            .padding(.horizontal, DesignTokens.Spacing.lg)
            .padding(.top, DesignTokens.Spacing.lg)
            .padding(.bottom, DesignTokens.Spacing.md)

            Divider()
                .overlay(DesignTokens.Colors.glassBorder)

            // Tab content
            switch selectedTab {
            case .stats:
                statsContent
            case .tasks:
                tasksContent
            }
        }
        .darkGlassBackground()
        .clipShape(RoundedRectangle(cornerRadius: DesignTokens.Dimensions.cornerRadius))
        .environment(\.colorScheme, .dark)
        .onExitCommand {
            if expandedCategory != nil {
                withAnimation(DesignTokens.Animation.quick) {
                    expandedCategory = nil
                }
            } else if let window = NSApplication.shared.keyWindow {
                window.close()
            }
        }
    }

    // MARK: - Tab Bar

    private var tabBar: some View {
        HStack(spacing: 2) {
            ForEach(IrieTab.allCases, id: \.self) { tab in
                Button {
                    withAnimation(DesignTokens.Animation.quick) {
                        selectedTab = tab
                    }
                } label: {
                    HStack(spacing: DesignTokens.Spacing.xs) {
                        Image(systemName: tab.icon)
                            .font(.system(size: 9))
                        Text(tab.rawValue)
                            .font(.system(size: 10, weight: .medium))
                    }
                    .padding(.horizontal, DesignTokens.Spacing.sm)
                    .padding(.vertical, DesignTokens.Spacing.xxs + 1)
                    .background(
                        Capsule()
                            .fill(selectedTab == tab ? Color.white.opacity(0.1) : Color.clear)
                    )
                    .foregroundStyle(
                        selectedTab == tab
                            ? DesignTokens.Colors.textPrimary
                            : DesignTokens.Colors.textTertiary
                    )
                }
                .buttonStyle(.plain)
            }
        }
        .padding(2)
        .background(
            Capsule()
                .fill(Color.white.opacity(0.04))
                .overlay(
                    Capsule()
                        .strokeBorder(DesignTokens.Colors.glassBorder, lineWidth: 0.5)
                )
        )
    }

    // MARK: - Stats Tab

    private var statsContent: some View {
        StatsGridView(systemMonitor: systemMonitor, expandedCategory: $expandedCategory)
    }

    // MARK: - Tasks Tab

    private var tasksContent: some View {
        ProcessListView(processes: systemMonitor.processes)
            .frame(maxHeight: DesignTokens.Dimensions.maxScrollHeight)
    }
}
