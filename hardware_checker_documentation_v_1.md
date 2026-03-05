# HardwareChecker

A Linux-based hardware inspection toolkit designed to help users evaluate second-hand laptops and desktops before purchase.

---

## 1. Overview

HardwareChecker is a Bash-based automation script that consolidates multiple Linux diagnostic utilities into a single executable workflow. It provides system-level hardware insights to help detect potential issues in used or refurbished machines.

This tool is especially useful when:
- Buying second-hand laptops or desktops
- Verifying hardware integrity before purchase
- Performing quick inspection during meetups
- Running diagnostics from a Live USB environment

⚠️ Apple (macOS) devices are not currently supported.

---

## 2. Features

- CPU information detection
- RAM information detection
- Disk and storage inspection
- SMART health checks (if supported)
- Power-on hours reporting
- Device model verification
- Automatic dependency installation (based on distro)
- Output logging to file
- Cross-distro compatibility

---

## 3. How It Works

HardwareChecker automates common Linux hardware inspection commands and runs them in a structured order. Instead of manually running multiple tools, users can execute a single script that:

1. Detects the system environment
2. Ensures required tools are installed
3. Executes hardware diagnostic commands
4. Compiles results into a readable report

The script queries hardware directly via Linux kernel interfaces such as:
- /proc
- /sys
- SMART disk controllers
- DMI firmware tables

This ensures hardware information is retrieved independently of the installed operating system.

---

## 4. Requirements

- Linux distribution (Arch, Debian, Fedora, etc.)
- Bash shell
- Root privileges (sudo)
- Internet connection (for first-time dependency installation)

Recommended usage:
Run from a Linux Live USB for clean, unbiased inspection.

---

## 5. Installation

Clone the repository:

```bash
git clone https://github.com/caljer075/HardwareChecker.git
cd HardwareChecker
```

Make the script executable:

```bash
chmod +x HardwareChecker.sh
```

---

## 6. Usage

Run with sudo:

```bash
sudo ./HardwareChecker.sh
```

The script will:
- Perform hardware checks
- Display results in terminal
- Save results to an output file

---

## 7. Output

The tool generates a structured hardware report including:

- CPU model and architecture
- Total RAM
- Storage devices and partitions
- Disk health indicators
- Power-on hours (if available)

This report can be used to:
- Compare against seller claims
- Detect high-wear storage devices
- Identify mismatched hardware specs

---

## 8. Limitations

- Not compatible with macOS systems
- Some SSD firmware may limit SMART reporting
- Certain vendor-locked devices may restrict access to hardware data
- Does not perform stress testing (yet)

---

## 9. Security & Privacy

HardwareChecker:
- Does not send data externally
- Does not modify system configuration
- Only reads hardware-level information
- Can be run entirely offline

---

## 10. Roadmap (Planned Improvements)

- Pass/Fail summary section
- Hardware health scoring system
- JSON export support
- Quick mode vs Full diagnostic mode
- Battery wear reporting enhancements
- Red flag detection for critical SMART values

---

## 11. Version

Current Version: v1.0

---

## 12. License

Specify your chosen open-source license here (MIT recommended for simplicity).

---

## 13. Contributing

Feedback, suggestions, and pull requests are welcome.

If you find this tool useful, consider:
- Opening an issue
- Suggesting improvements
- Reporting bugs

---

Built for transparency, verification, and smarter second-hand purchases.

