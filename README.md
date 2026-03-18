# Irie

A lightweight macOS menu bar app that displays live system stats in a dark glassmorphism popover. Everything running smooth.

## Features

- **CPU** — Overall usage bar + per-core breakdown
- **Memory** — Usage bar with active/wired/compressed breakdown
- **Disk** — Root volume usage
- **Network** — Live upload/download rates
- **Process list** — Sortable table of all running processes with CPU%, memory, and thread count

Stats auto-refresh every 2 seconds. No dock icon — lives entirely in the menu bar.

## Install

```bash
brew install --cask AbdulEmad/tap/irie
```

Or build from source:

```bash
git clone https://github.com/AbdulEmad/irie.git
cd irie
swift build
swift run
```

> **Note:** If macOS blocks the app with "can't verify the developer", run:
> ```bash
> xattr -cr /Applications/Irie.app
> ```

## Keyboard Shortcuts

- **Escape** — Close the popover

## Architecture

```
Sources/Irie/
├── IrieApp.swift                # MenuBarExtra entry point
├── Models/
│   ├── SystemStats.swift        # CPU, memory, disk, network data models
│   └── ProcessStats.swift       # Process data model
├── Services/
│   ├── SystemMonitor.swift      # @Observable orchestrator with Timer
│   ├── CPUMonitor.swift         # host_processor_info (per-core deltas)
│   ├── MemoryMonitor.swift      # host_statistics64
│   ├── DiskMonitor.swift        # FileManager filesystem attributes
│   ├── NetworkMonitor.swift     # getifaddrs byte counter deltas
│   └── ProcessMonitor.swift     # proc_pidinfo task info
├── Views/
│   ├── MenuBarPopupView.swift   # Tabbed layout (Stats / Tasks)
│   ├── Sections/
│   │   ├── CPUSectionView.swift
│   │   ├── MemorySectionView.swift
│   │   ├── DiskSectionView.swift
│   │   ├── NetworkSectionView.swift
│   │   └── ProcessListView.swift
│   └── Components/
│       ├── UsageBar.swift       # Animated horizontal bar
│       ├── StatRow.swift        # Label + value pair
│       └── SectionHeader.swift  # Uppercase section header
└── DesignSystem/
    ├── DesignTokens.swift       # Colors, spacing, typography
    ├── VisualEffectBackground.swift  # NSVisualEffectView glass background
    └── ViewModifiers.swift      # Hoverable rows, glass buttons
```

## System APIs Used

| Metric  | API                          |
|---------|------------------------------|
| CPU     | `host_processor_info()`      |
| Memory  | `host_statistics64()`        |
| Disk    | `FileManager.attributesOfFileSystem(forPath:)` |
| Network | `getifaddrs()` + `if_data`   |
| Processes | `proc_listallpids()` + `proc_pidinfo()` |

## License

MIT
