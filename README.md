# MattsMod - Ultimate Boss & DLC Access for Lies of P

**Instant access to any boss fight + complete DLC integration + external debugging for Lies of P**

[![Lua](https://img.shields.io/badge/language-Lua-blue.svg)](https://www.lua.org/)
[![UE4SS](https://img.shields.io/badge/framework-UE4SS-green.svg)](https://github.com/UE4SS-RE/RE-UE4SS)
[![Game](https://img.shields.io/badge/game-Lies%20of%20P-red.svg)](https://liesofp.com/)

## 🎯 Overview

MattsMod is a comprehensive UE4SS-based modification for Lies of P that provides instant access to boss challenges, complete DLC integration, advanced save game manipulation, and external debugging capabilities. Built with professional-grade Lua scripting, it offers both hotkey convenience and powerful console commands with intelligent fallback systems.

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

### 🔧 External Debugging & Development
- **Live code execution** via LuaReplDebug
- **Socket-based communication** with Python tools
- **Real-time mod development** and testing
- **Professional debugging interface**

## 🚀 Quick Start

### Prerequisites
- **[UE4SS for Lies of P](https://www.nexusmods.com/liesofp/mods/259)** - Custom UE4SS build specifically for Lies of P
- Lies of P (Steam/Epic Games)

### Installation
1. Install UE4SS in your Lies of P directory
2. Clone this repository: `git clone [your-repo-url] MattsMod`
3. Clone the shared framework: `git clone [shared-framework-url] MattsMod/shared`
4. Add `MattsMod: 1` to your `mods.txt`
5. Launch the game

### Basic Usage
```lua
-- Console Commands (press ~ or F10)
goto_boss 1                    -- Teleport to Parade Master
list_boss_challenges           -- Show all available bosses
teleport_to LD_Hotel_Main      -- Teleport to any location
set_teleport_target LD_Hotel_Main -- Set pocket watch override
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
| `set_teleport_target <location>` | Set pocket watch override target | `set_teleport_target LD_Hotel_Main` |

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
    if teleport_target ~= FName("") then
        self.Payload.TeleportTarget = teleport_target
    end
end)
```

### Global Functions for External Debugger
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

- **Base Game Areas**: Hotel, Station, Factory, Cathedral, Old Town, etc.
- **DLC Content**: Krat Zoo, Deserted Hotel, Underground Lab, Winter Sea
- **Boss Challenges**: All 18 chapter-based boss arenas
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

### Shared Framework
This mod depends on a shared framework containing:
- **UEHelpers** - UE4SS utility functions
- **Utils** - Logging and common utilities  
- **LuaReplDebug** - External debugging system
- **Socket libraries** - Network communication (LuaSocket by Diego Nehab)
- **Type definitions** - 700+ UE4 class definitions
- **dkjson** - JSON parsing (by David Kolf)

### File Structure
```
MattsMod/
├── Scripts/
│   ├── main.lua                 # Core implementation (600+ lines)
│   ├── teleport_locations.txt   # Generated location reference
│   └── socket/                  # Socket communication files
├── shared/                      # Shared framework (git submodule)
│   ├── UEHelpers/
│   ├── Utils/
│   ├── LuaReplDebug/
│   ├── types/
│   └── socket.lua
└── README.md
```

### Code Quality Features
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