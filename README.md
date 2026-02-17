<div align="center">
🎒 zqmvo_sling
Advanced Weapon Sling System for FiveM

Built for ESX + ox_inventory










</div>
📌 Overview

zqmvo_sling is a fully synced weapon sling system designed for serious roleplay servers.

It integrates directly with ox_inventory, supports custom add-on weapons, and ensures that attachments remain visible while slung.

Built for performance, realism, and clean synchronization.

🔥 Features

Fully synced (everyone sees slung weapons)

ox_inventory integration

Add-on weapon compatible

Attachments visible while slung

PD-only restriction (configurable)

Blocks drawing slung weapons

ox_lib notifications

Clean network sync

No inventory removal

Uses weapon objects (not fake props)

🎥 Preview

Add screenshots or GIFs here:




🔒 Weapon Draw Lock System

If a player attempts to equip a weapon that is currently slung:

"You currently have this weapon slung. Unsling it first."

The system will:

Instantly disarm the player

Block usage until unslung

Prevent animation abuse

📦 Requirements

ox_inventory

ox_lib

ESX Framework

⚙️ Installation

Drag zqmvo_sling into your resources folder.

Add this to your server.cfg:

ensure ox_lib
ensure ox_inventory
ensure zqmvo_sling

Restart your server.

🎮 Commands

/sling 1 → Front sling
/sling 2 → Back sling

👮 Job Restriction

Edit config.lua:

Config.AllowedJobs = {
  'police',
  'offpolice'
}


Remove offpolice if you do not want off-duty officers to sling weapons.

🔫 Add-On Weapon Support

Automatically supports:

Custom weapon hashes (example: WEAPON_MCX)

Custom magazines

Custom suppressors

Custom scopes

Custom grips

If attachments do not show while slung:

Verify component hash exists

Verify metadata stores components

Ensure mapping exists in config.lua

🛠 Troubleshooting
Weapon says "Holstered Now"

This is normal ox_inventory behavior when disarming.

Attachments Not Showing

Check:

Component hash exists in weapons.lua

Metadata is correctly storing components

Attachment mapping exists in config.lua

🧠 How It Works

Reads current weapon + metadata from ox_inventory

Sends weapon hash + component list to server

Server syncs to all clients

Each client creates a CreateWeaponObject

Components applied using GiveWeaponComponentToWeaponObject

🚀 Planned Updates

Multi-weapon sling slots

Improved sling animations

QBCore support

Configurable bone positioning

Performance optimization pass

📄 License

Free to use and modify.
Do not resell.

<div align="center">

Made for serious RP servers.

</div>
