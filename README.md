<div align="center">

# 🎒 zqmvo_sling

**Advanced Weapon Sling System for FiveM**

Built for ESX + ox_inventory

![FiveM](https://img.shields.io/badge/FiveM-Resource-blue?style=flat-square)
![ESX](https://img.shields.io/badge/Framework-ESX-orange?style=flat-square)
![ox_inventory](https://img.shields.io/badge/Inventory-ox__inventory-green?style=flat-square)
![License](https://img.shields.io/badge/License-Free%20to%20Use-lightgrey?style=flat-square)

</div>

---

## 📌 Overview

`zqmvo_sling` is a fully synced weapon sling system designed for serious roleplay servers. It integrates directly with `ox_inventory`, supports custom add-on weapons, and ensures that attachments remain visible while slung.

Built for performance, realism, and clean synchronization.

---

## 🔥 Features

| Feature | Status |
|---|---|
| Fully synced (all clients see slung weapons) | ✅ |
| `ox_inventory` integration | ✅ |
| Add-on weapon compatible | ✅ |
| Attachments visible while slung | ✅ |
| PD-only restriction (configurable) | ✅ |
| Blocks drawing slung weapons | ✅ |
| `ox_lib` notifications | ✅ |
| Clean network sync | ✅ |
| No inventory removal | ✅ |
| Uses weapon objects (not fake props) | ✅ |

---

## 🎥 Preview

> Add screenshots or GIFs here.

---

## 📦 Requirements

- [`ox_inventory`](https://github.com/overextended/ox_inventory)
- [`ox_lib`](https://github.com/overextended/ox_lib)
- [ESX Framework](https://github.com/esx-framework/esx_core)

---

## ⚙️ Installation

1. Drag `zqmvo_sling` into your `resources` folder.
2. Add the following to your `server.cfg`:

```cfg
ensure ox_lib
ensure ox_inventory
ensure zqmvo_sling
```

3. Restart your server.

---

## 🎮 Commands

| Command | Description |
|---|---|
| `/sling 1` | Front sling |
| `/sling 2` | Back sling |

---

## 👮 Job Restriction

Edit `config.lua` to configure which jobs can use the sling system:

```lua
Config.AllowedJobs = {
    'police',
    'offpolice'
}
```

> Remove `'offpolice'` if you do not want off-duty officers to sling weapons.

---

## 🔒 Weapon Draw Lock System

If a player attempts to equip a weapon that is currently slung, they will receive the following notification:

> *"You currently have this weapon slung. Unsling it first."*

The system will then:
- Instantly disarm the player
- Block weapon usage until unslung
- Prevent animation abuse

---

## 🔫 Add-On Weapon Support

The system automatically supports:
- Custom weapon hashes (e.g. `WEAPON_MCX`)
- Custom magazines
- Custom suppressors
- Custom scopes
- Custom grips

**If attachments are not showing while slung, verify the following:**
- Component hash exists in `weapons.lua`
- Metadata is correctly storing components
- Attachment mapping exists in `config.lua`

---

## 🧠 How It Works

1. Reads current weapon + metadata from `ox_inventory`
2. Sends weapon hash + component list to the server
3. Server syncs data to all clients
4. Each client creates a `CreateWeaponObject`
5. Components applied using `GiveWeaponComponentToWeaponObject`

---

## 🛠 Troubleshooting

**Weapon says "Holstered Now"**

This is normal `ox_inventory` behavior when disarming. No action needed.

**Attachments Not Showing**

Check the following:
- Component hash exists in `weapons.lua`
- Metadata is correctly storing components
- Attachment mapping exists in `config.lua`

---

## 🚀 Planned Updates

- [ ] Multi-weapon sling slots
- [ ] Improved sling animations
- [ ] QBCore support
- [ ] Configurable bone positioning
- [ ] Performance optimization pass

---

## 📄 License

Free to use and modify. **Do not resell.**

---

<div align="center">

Made with ❤️ for serious RP servers.

</div>
