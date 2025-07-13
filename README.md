# MattsMod - Ultimate Boss & DLC Access for Lies of P

**Instant access to any boss fight + complete DLC integration for Lies of P**

[![Lua](https://img.shields.io/badge/language-Lua-blue.svg)](https://www.lua.org/)
[![UE4SS](https://img.shields.io/badge/framework-UE4SS-green.svg)](https://github.com/UE4SS-RE/RE-UE4SS)
[![Game](https://img.shields.io/badge/game-Lies%20of%20P-red.svg)](https://liesofp.com/)

## 🎯 Overview

MattsMod is a comprehensive UE4SS-based modification for Lies of P that provides instant access to boss challenges, complete DLC integration, and advanced save game manipulation. Built with professional-grade Lua scripting, it offers both hotkey convenience and powerful console commands.

## ✨ Key Features

### 🏆 Boss Challenge System
- **18 mapped boss fights** with human-readable names
- **Instant teleportation** via `goto_boss <chapter>`
- **Smart filtering** (removes portal/clear variants)
- **Contextual warnings** for problematic bosses
- **Comprehensive listing** with `list_boss_challenges`

### 🎮 DLC Access Revolution
- **Instant DLC access** from any save state
- **NG+ manipulation** (F3/F4 hotkeys)
- **Reward item unlocking** (F5)
- **Seamless integration** with base game progression

### 🌍 Universal Teleportation
- **200+ game locations** organized by area
- **Dynamic location discovery** and export (F6)
- **Smart categorization** (Hotel, Station, Zoo, Winter Sea, etc.)
- **Universal teleport command** for any location

### 🛠️ Advanced Save Manipulation
- **Humanity control** (F7 sets to 99)
- **NG+ round management**
- **Save game data inspection**
- **Character progression modification**

## 🚀 Quick Start

### Prerequisites
- **[UE4SS for Lies of P](https://www.nexusmods.com/liesofp/mods/259)** - Custom UE4SS build specifically for Lies of P
- Lies of P (Steam/Epic Games)

### Installation
1. Install UE4SS in your Lies of P directory
2. Copy `main.lua` to `LiesofP/Binaries/Win64/Mods/MattsMod/Scripts/`
3. Add `MattsMod: 1` to your `mods.txt`
4. Launch the game

### Basic Usage
```lua
-- Console Commands (press ~ or F10)
goto_boss 1                    -- Teleport to Parade Master
list_boss_challenges           -- Show all available bosses
teleport_to LD_Hotel_Main      -- Teleport to any location
set_ng_plus_round 10          -- Set NG+ round

-- Hotkeys (in-game)
F2  -- Teleport to DLC start area
F3  -- Enable NG+10 DLC access
F4  -- Reset to base game state
F5  -- Unlock DLC reward items
F6  -- Export all teleport locations
F7  -- Set humanity to 99
```

## 📋 Commands Reference

### Boss Commands
| Command | Description | Example |
|---------|-------------|---------|
| `goto_boss <chapter>` | Teleport to specific boss | `goto_boss 7` |
| `list_boss_challenges` | Show all bosses with IDs | `list_boss_challenges` |

### Teleportation
| Command | Description | Example |
|---------|-------------|---------|
| `teleport_to <location>` | Teleport to any game location | `teleport_to DLC_LD_Winter_Sea_Portal` |

### Save Manipulation
| Command | Description | Example |
|---------|-------------|---------|
| `set_ng_plus_round <num>` | Set NG+ round | `set_ng_plus_round 5` |

## 🎭 Boss Roster

Complete coverage of all 18 boss challenges:

| Chapter | Boss Name | Special Notes |
|---------|-----------|---------------|
| 1 | Parade Master | ✅ Working |
| 2 | Scrapped Watchman | ✅ Working |
| 3 | Kings Flame, Fuoco | ✅ Working |
| 4 | Fallen Archbishop Andreus | ✅ Working |
| 5 | Eldest of the Black Rabbit Brotherhood | ✅ Working |
| 6 | King of Puppets | ✅ Working |
| 7 | Champion Victor | ✅ Working |
| 8 | Green Monster of the Swamp | ✅ Working |
| 9 | Corrupted Parade Master | ✅ Working |
| 11 | Black Rabbit Brotherhood | ✅ Working |
| 12 | Laxasia the Complete | ✅ Working |
| 13 | Simon Manus, Arm of God | ✅ Working |
| 14 | Nameless Puppet | ⚠️ Requires specific game conditions |
| 15 | Markiona, Puppeteer of Death | ✅ Working |
| 16 | Anguished Guardian of the Ruins | ✅ Working |
| 17 | Arlecchino the Blood Artist | ⚠️ Requires Winter Sea Mansion visit |
| 18 | Two-faced Overseer | ✅ Working |

*Note: Chapter 10 is missing from the game's boss challenge system*

## 🏗️ Technical Implementation

### Architecture Highlights
- **Modular function design** with clear separation of concerns
- **Type-annotated Lua** for UE4SS API integration
- **Robust error handling** with user-friendly messages
- **Dynamic game data discovery** and categorization
- **Professional CLI interface** with contextual help

### Key Technical Features
```lua
-- Dynamic location discovery from game assets
local teleport_object_info_asset = FindAllOf('TeleportObjectInfoAsset')

-- Direct save game manipulation
local save_game_data = UEHelpers.GetPlayerController().Character.PlayingGameData
character_data.NewGamePlus_Round = target_round

-- Smart location categorization with pattern matching
elseif string.match(spot, "^DLC_BC_CH%d+_") then
    table.insert(grouped.boss_challenges, spot)
```

### Error Handling & UX
- Graceful failure with informative error messages
- Automatic help display for incomplete commands
- Contextual warnings for problematic game states
- Consistent logging through Utils framework

## 📊 Location Categories

The mod organizes 200+ game locations into logical categories:

- **Base Game Areas**: Hotel, Station, Factory, Cathedral, Old Town, etc.
- **DLC Content**: Krat Zoo, Deserted Hotel, Underground Lab, Winter Sea
- **Boss Challenges**: All 18 chapter-based boss arenas
- **Special Locations**: Portals, entry points, main areas

## 🔧 Development

### Code Quality Features
- Type annotations for UE4SS API
- Consistent naming conventions (snake_case)
- Comprehensive error handling
- Clean module dependency management
- Professional documentation standards

### File Structure
```
MattsMod/
├── Scripts/
│   ├── main.lua                 # Core implementation (502 lines)
│   └── teleport_locations.txt   # Generated location reference
└── .luarc.json                  # Lua development configuration
```

## 🎮 Use Cases

- **Speedrunners**: Practice specific bosses instantly
- **Content Creators**: Quick setup for boss showcase videos  
- **Challenge Runners**: Easy access for themed runs
- **Casual Players**: Replay favorite boss fights
- **Modders/Developers**: Location discovery and save manipulation tools

## ⚠️ Important Notes

- **Backup your save files** before using save manipulation features
- **Use pocket watch first** - teleportation requires stargazer activation
- **DLC access requires save/reload** after NG+ manipulation
- Some bosses have specific unlock requirements (noted in warnings)

## 🤝 Contributing

This project demonstrates professional Lua development practices and UE4SS integration techniques. Feel free to study the code for educational purposes.

## 📜 License

This project is shared freely for educational and personal use. The code serves as a demonstration of game modding techniques and Lua scripting capabilities.

---

**Built with ❤️ for the Lies of P community** 