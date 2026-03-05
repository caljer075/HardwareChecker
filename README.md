HARDWARE CHECKER v1.3

Checks CPU, GPU, RAM, Storage, SSD Health, and Battery info on Linux systems

Works on: Ubuntu, Mint, Debian, Arch, Manjaro, Fedora, openSUSE (and most derivatives).

---

 ◽ Features

 Detects CPU, RAM, GPU, Storage, Battery info
 Runs a quick CPU stress test and reads temperatures via sensors
 Checks SSD/NVMe health via SMART data (smartctl)
 Auto-installs missing tools (smartctl, dmidecode, stress, upower, lscpu, lsblk, lspci, sensors) if a supported package manager is detected
 Outputs results to terminal and a timestamped text file
 
 HardwareChecker is intended for buyers who want to validate system hardware before purchasing second-hand laptops or desktops, particularly from unverified sellers using a Linux Live USB.

 ⚠️ Note: Apple (macOS) devices are not supported at this time.

---

 ◽ Requirements

 Linux OS with root accesss
 Optional: Wi-Fi for auto-install of missing packages
 Recommended tools (script will try to install if missing):

   smartctl (smartmontools)
   dmidecode
   stress
   upower
   lscpu, lsblk, lspci, sensors

---

 ◽ Usage

1. Make the script executable:

   chmod +x HardwareChecker.sh
   
2. Run the script:

   ./HardwareChecker.sh
   
3. Optional: auto-install all missing tools without prompts:

   ./HardwareChecker.sh -y
   
4. Output will also be saved in a timestamped file like:

   hardwarecheck-20260305-142530.txt
   

---

 ⚠️ Notes

 Works on laptops and desktops (battery info may be missing on desktops)
 GPU-specific commands may require additional drivers/tools:

  NVIDIA → nvidia-smi

  AMD → rocm-smi

  Intel → intel_gpu_top

CPU stress test is quick (10s) for safety, can be modified in the script

---

 📣 Contribution / Feedback

 Open to suggestions for new checks, output formats (JSON/CSV), multi-drive support, or GPU enhancements
 Ideal for sharing in forums, or with users buying/repairing second hand laptops or desktops
