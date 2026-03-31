# BSM Weapon Control System

<div align="center">
  <h3>Advanced, Professional, & Highly Optimized Weapon Disarm System for FiveM</h3>
  <p>Engineered for high-population Roleplay servers seeking perfect discipline and combat moderation. Designed by <b>Basil Saji Mathew (BSM)</b>.</p>
</div>

## ✨ Features
- **Highly Optimized Performance**: Event-driven hooks, local ped caching, minimal 0.00ms resmon on idle.
- **Universal Compatibility**: Plug-and-play support for **ESX**, **QBCore**, **Qbox**, and **Standalone**.
- **Dynamic Radius System**: Silence a chaotic scene instantly! Disable or enable weapons for everyone nearby.
- **Item-Driven Execution**: No commands required. Utilize custom `ox_inventory` usable items natively with progress bars.
- **Auto Disarm Mechanisms**: Temporarily disarm players upon death, reviving, or inside designated Safe Zones.
- **Persistent Punishments**: MySQL integration guarantees that players who relog cannot bypass their weapon cooldowns!
- **Complete Customization**: Control bypass jobs, admin whitelist, cooldowns, notifications, UI progress bars, and Discord webhooks!
- **Clean Interface**: Integrated natively with `ox_lib` notifications and progress implementations, fully open-sourced for custom edits.

## 📦 Dependencies
Ensure that the following are installed and running smoothly:
- [`ox_lib`](https://github.com/overextended/ox_lib)
- [`ox_inventory`](https://github.com/overextended/ox_inventory)
- [`oxmysql`](https://github.com/overextended/oxmysql)

## 📖 Installation & Usage
Please see the `docs/` folder for comprehensive setup guides:
- [INSTALL.md](./docs/INSTALL.md) - Step-by-step installation instructions.
- [CONFIG.md](./docs/CONFIG.md) - Detailed breakdown of the configuration options.
- [USAGE.md](./docs/USAGE.md) - Admin usage and developer exports guide.

## 🛠 Exports for Developers
You can trigger disarm remotely from your other resources! See `docs/USAGE.md` for more details.
```lua
exports.bsm_weapon_control:disableWeapons(targetId, minutes, reason)
exports.bsm_weapon_control:enableWeapons(targetId)
```

## 📜 License & Credits
- **Author**: Basil Saji Mathew (BSM)
- **License**: All rights reserved. Do not redistribute without explicit permission. Look premium, feel premium.
