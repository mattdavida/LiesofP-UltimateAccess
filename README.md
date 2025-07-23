# LiesofP-UltimateAccess - Complete Game Enhancement Suite

**Comprehensive gameplay enhancements, boss/DLC access, save manipulation, and debugging tools for Lies of P**

[![Lua](https://img.shields.io/badge/language-Lua-blue.svg)](https://www.lua.org/)
[![UE4SS](https://img.shields.io/badge/framework-UE4SS-green.svg)](https://github.com/UE4SS-RE/RE-UE4SS)
[![Game](https://img.shields.io/badge/game-Lies%20of%20P-red.svg)](https://liesofp.com/)

## 🎯 Overview

LiesofP-UltimateAccess is a comprehensive UE4SS-based modification for Lies of P that provides instant access to boss challenges, complete DLC integration, advanced save game manipulation, gameplay enhancements, and external debugging capabilities. Built with professional-grade modular Lua architecture, it offers both hotkey convenience and powerful console commands with intelligent fallback systems.

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

### 🌍 Advanced Teleportation System
- **200+ game locations** organized by area
- **Smart fallback system** - auto-sets pocket watch target if direct teleport fails
- **Pocket watch override hooks** - seamless teleport redirection
- **Dynamic location discovery** and export (F6)
- **Smart categorization** (Hotel, Station, Zoo, Winter Sea, etc.)
- **Universal teleport command** for any location
- **Global functions** for other mods to integrate

### 🛠️ Advanced Save Manipulation
- **Humanity control** (F7 sets to 99)
- **NG+ round management**
- **Save game data inspection**
- **Character progression modification**
- **Soul/Ergo multiplier system** with configurable rates

### 🔧 External Debugging & Development
- **Live code execution** via LuaReplDebug
- **Socket-based communication** with Python tools
- **Real-time mod development** and testing
- **Professional debugging interface**

### 🎮 Enhanced Gameplay Features
- **Better jump mechanics** (F8) - Enhanced velocity and reduced animation times
- **Hair color customization** via console commands
- **Advanced movement controls**

## 🚀 Quick Start

### Prerequisites
- **[UE4SS for Lies of P](https://www.nexusmods.com/liesofp/mods/259)** - Custom UE4SS build specifically for Lies of P
- Lies of P (Steam/Epic Games)

### Installation
1. Install UE4SS in your Lies of P directory
2. Clone this repository: `git clone [your-repo-url] LiesofP-UltimateAccess`
3. Add `LiesofP-UltimateAccess: 1` to your `mods.txt`
4. Launch the game

### Basic Usage
```lua
-- Console Commands (press ~ or F10)
goto_boss 1                    -- Teleport to Parade Master
list_boss_challenges           -- Show all available bosses
teleport_to LD_Hotel_Main      -- Teleport to any location
set_teleport_target LD_Hotel_Main -- Set pocket watch override
set_ng_plus_round 10          -- Set NG+ round
set_souls_multiply 2.0        -- Set soul collection multiplier

-- Hotkeys (in-game)
F2  -- Teleport to DLC start area
F3  -- Enable NG+10 DLC access
F4  -- Reset to base game state
F5  -- Unlock DLC reward items
F6  -- Export all teleport locations
F7  -- Set humanity to 99
F8  -- Enable better jump mechanics
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
| `set_teleport_target <location>` | Set pocket watch override target | `set_teleport_target LD_Hotel_Main` |

### Save Manipulation
| Command | Description | Example |
|---------|-------------|---------|
| `set_ng_plus_round <num>` | Set NG+ round | `set_ng_plus_round 5` |
| `set_souls_multiply <multiplier>` | Set soul collection multiplier | `set_souls_multiply 10.0` |
| `set_hair_color <color>` | Change hair color (0-5) | `set_hair_color 2` |

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

### Modular Architecture
The mod features a clean, professional modular architecture:

```
Scripts/
├── main.lua                 # Module loader and orchestration
├── mod_globals.lua          # Global variables and shared functions
├── teleport.lua             # Complete teleportation API and location management
├── console_commands.lua     # All console command handlers
├── keybinds.lua             # Hotkey bindings for various features
├── ergo_multiplier.lua      # Soul/Ergo collection multiplier system
├── better_jumps.lua         # Enhanced jumping mechanics
├── teleport_locations.txt   # Generated location reference (192 locations)
└── socket/                  # Socket communication files
```

### Smart Teleportation System
The mod features an intelligent fallback system:
```lua
-- Direct teleport if action available
if action_teleport_start then
    bp.Payload.TeleportTarget = target
    bp:Start()
else
    -- Auto-set pocket watch target
    SetTeleportTarget(target)
    -- User just needs to use pocket watch
end
```

### Pocket Watch Override Hooks
Seamless teleport redirection using UE4SS hooks:
```lua
RegisterHook("BP_Action_Teleport_Start_C:OnStart", function(self)
    if TeleportTarget ~= FName("") then
        self.Payload.TeleportTarget = TeleportTarget
    end
end)
```

### Module Dependencies
- **mod_globals.lua** - Core global variables and shared functions
- **teleport.lua** - Location management and teleportation API
- **console_commands.lua** - Command handlers requiring globals and teleport API
- **keybinds.lua** - Hotkey bindings using teleport and jump modules
- **ergo_multiplier.lua** - Soul collection enhancement hooks
- **better_jumps.lua** - Movement and animation modifications

### Global Functions for External Integration
```lua
-- Available functions for UE4SS external debugger/REPL tool
TeleportTo(destination)           -- Direct teleportation from external tool
SetTeleportTarget(target)         -- Set pocket watch target from external tool  
GetGroupedTeleportSpots()         -- Get categorized locations for external analysis
```

### External Debugging
Real-time debugging via socket communication:
- **LuaReplDebug** - Live code execution
- **Socket libraries** - Network communication
- **Python integration** - External tool support

## 📊 Location Categories & Boss Arena Handling

The mod organizes 200+ game locations into logical categories:

- **Base Game Areas**: Hotel (20), Station (11), Factory (5), Cathedral (7), Old Town (5), etc.
- **DLC Content**: Krat Zoo (13), Winter Sea (16), Underground Lab (6), Deserted Hotel (4)
- **Boss Challenges**: All 18 chapter-based boss arenas (51 total including variants)
- **Special Locations**: Portals, entry points, main areas

### Boss Arena Limitation & Workaround
**From boss arenas**: Commands automatically set pocket watch target instead of direct teleport
```
goto_boss 5               # Sets target, prompts to use pocket watch
# Use pocket watch -> teleports to Chapter 5 boss
```

**Alternative**: Teleport to hotel first, then to destination
```
teleport_to LD_Hotel_Main  # Go to safe location first
goto_boss 5               # Now works directly
```

## 🔧 Development & Dependencies

### Dependencies
This mod requires the UE4SS framework and utilizes:
- **UEHelpers** - UE4SS utility functions for player/controller access
- **Utils** - Logging and common utilities for clean console output
- **LuaReplDebug** - External debugging system for live development
- **Socket libraries** - Network communication (LuaSocket by Diego Nehab)

### Project Structure
```
LiesofP-UltimateAccess/
├── Scripts/
│   ├── main.lua                 # Module loader and orchestration
│   ├── mod_globals.lua          # Global variables and shared functions  
│   ├── teleport.lua             # Complete teleportation API and location management
│   ├── console_commands.lua     # All console command handlers
│   ├── keybinds.lua             # Hotkey bindings for various features
│   ├── ergo_multiplier.lua      # Soul/Ergo collection multiplier system
│   ├── better_jumps.lua         # Enhanced jumping mechanics
│   ├── teleport_locations.txt   # Generated location reference (192 locations)
│   └── socket/                  # Socket communication files
├── LICENSE
└── README.md
```

### Code Quality Features
- **Modular architecture** with clear separation of concerns
- **Type annotations** for UE4SS API
- **Consistent naming** conventions (snake_case)
- **Comprehensive error handling** with user-friendly messages
- **Clean module dependency** management
- **Professional documentation** standards
- **Hook-based architecture** for seamless integration

## 🎮 Use Cases

- **Speedrunners**: Practice specific bosses instantly
- **Content Creators**: Quick setup for boss showcase videos  
- **Challenge Runners**: Easy access for themed runs
- **Casual Players**: Replay favorite boss fights
- **Modders/Developers**: Location discovery, save manipulation, and debugging tools
- **Python Developers**: External tool integration via socket communication

## ⚠️ Important Notes

- **Backup your save files** before using save manipulation features
- **Use pocket watch first** - teleportation requires stargazer activation
- **DLC access requires save/reload** after NG+ manipulation
- Some bosses have specific unlock requirements (noted in warnings)
- **Hooks require mod refresh** after game start for proper initialization

## 🤝 Contributing

This project demonstrates professional Lua development practices and UE4SS integration techniques. The external debugging system allows for real-time development and testing.

## 📜 License

This project is shared freely for educational and personal use. The code serves as a demonstration of game modding techniques and Lua scripting capabilities.

**Dependencies:**
- **LuaSocket**: MIT License (Diego Nehab and contributors)
- **dkjson**: MIT License (David Kolf)

---

**Built with ❤️ for the Lies of P community** 