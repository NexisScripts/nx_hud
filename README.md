# 🖥️ nx_hud | Nexis Scripts

![Version](https://img.shields.io/badge/version-2.2.0-blue.svg)
![Framework](https://img.shields.io/badge/framework-Qbox%20%7C%20QBCore%20%7C%20ESX%20%7C%20Standalone-success.svg)
![Performance](https://img.shields.io/badge/performance-0.00ms-brightgreen.svg)
![License](https://img.shields.io/badge/license-MIT-orange.svg)

A modern, sleek, and highly optimized UI for your FiveM server. Designed with a clean "Glassmorphism" aesthetic, **nx_hud** operates at peak performance (~0.00ms idle) using an event-driven architecture instead of heavy client loops.

## ✨ Key Features

* **⚡ Ultra Optimized:** Zero race conditions thanks to a built-in `nuiReady` callback. Runs at ~0.02ms when walking.
* **🧠 Smart Auto-Detection:** Automatically detects **Qbox, QBCore, ESX, or Standalone** environments. No config changes required for framework setup!
* **🏎️ Dynamic Car HUD:** 
  * Progressive RPM ring and Speedometer.
  * Live Fuel gauge.
  * Smart Check Engine light (changes color from Green -> Yellow -> Red based on engine health).
* **🛡️ State Bag Seatbelt:** Directly reads `LocalPlayer.state.seatbelt` (or `isBuckled`) for instant synchronization with modern frameworks.
* **💳 Player Info Panel:** Floating top-right panel displaying Player ID, Job (with grade), Cash, and Bank balances (with auto-formatting for large numbers).
* **🛠️ Scaleform Fixes:** Built-in scaleform hooks to permanently disable default GTA V health/armor bars without breaking minimap textures (`SetRadarBigmapEnabled` hack included).

---

## 📸 Showcase

* **Idle (On Foot):** `(https://i.imgur.com/l8c3JYU.jpeg)`
* **Vehicle HUD:** `[<img width="372" height="199" alt="Discord_Z5XhhPi387" src="https://github.com/user-attachments/assets/0dff0932-31c9-45b5-9ee7-c628625aaad7" />](https://i.imgur.com/pik8ieb.png)`
* **Resmon (Performance):** `(https://i.imgur.com/nomU6Ha.png)`

---

## 📦 Installation

1. Download the latest version from the repository.
2. Extract the folder and rename it to `nx_hud` (Make sure there are no `-main` suffixes).
3. Place `nx_hud` into your server's `resources` folder.
4. Add the following line to your `server.cfg`:
```cfg
ensure nx_hud
