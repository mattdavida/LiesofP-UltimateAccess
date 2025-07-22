local Utils = require("Utils.Utils")
local UEHelpers = require("UEHelpers.UEHelpers")
local TeleportApi = require("teleport")
local ModGlobals = require("mod_globals")
-- require("mod_globals")

local function teleport_to(FullCommand, Parameters, Ar)
    Utils.Log(Ar, "Teleporting to " .. tostring(Parameters[1]))
    local location = tostring(Parameters[1])
    ---@class UBP_Action_Teleport_Start_C : ULAction_LoopAnim
    local action_teleport_start = FindAllOf('BP_Action_Teleport_Start_C')
    if action_teleport_start then
        for _, bp in pairs(action_teleport_start) do
            local dlc_entry_target = FName(location)
            bp.Payload.TeleportTarget = dlc_entry_target
            -- LActPayload_Teleport - see current targets in live view
            bp:Start()
            break
        end
    else
        Utils.Log(Ar,
            "No action teleport start found -- setting teleport target. please try to use pocket watch now to go to: " ..
            location)
        ModGlobals.SetTeleportTarget(location)
    end
    return true
end

local function set_ng_plus_round(FullCommand, Parameters, Ar)
    local round = tostring(Parameters[1])
    local save_game_data = UEHelpers.GetPlayerController().Character.PlayingGameData
    if save_game_data then
        local character_data = save_game_data.CharacterSaveData
        character_data.NewGamePlus_Round = round
        Utils.Log(Ar,
            "New Game Plus Round set to: " .. round .. " - save to title and reload game for the change to take effect")
    end
    return true
end

local function list_boss_challenges(FullCommand, Parameters, Ar)
    -- Boss name mapping based on chapter order
    local boss_names = {
        [1] = "Parade Master",
        [2] = "Scrapped Watchman",
        [3] = "Kings Flame, Fuoco",
        [4] = "Fallen Archbishop Andreus",
        [5] = "Eldest of the Black Rabbit Brotherhood",
        [6] = "King of Puppets",
        [7] = "Champion Victor",
        [8] = "Green Monster of the Swamp",
        [9] = "Corrupted Parade Master",
        [11] = "Black Rabbit Brotherhood", --CH11 -- 10 is missing
        [12] = "Laxasia the Complete",     --CH12
        [13] = "Simon Manus, Arm of God",  --CH13
        [14] = "Nameless Puppet",          --CH14 -- Puppet Master - must defeat simon manus first + level 10 humanity + max acquisition humanity -- ( F7 ) - then refuse to give heart.
        [15] = "Markiona, Puppeteer of Death",
        [16] = "Anguished Guardian of the Ruins",
        [17] = "Arlecchino the Blood Artist", -- need to have visited DLC_LD_Winter_Sea_Mansion_2F before the teleport will work
        [18] = "Two-faced Overseer",
    }


    local spots = TeleportApi.get_teleport_spots()

    if spots then
        local grouped_spots = TeleportApi.group_teleport_spots(spots)

        -- Filter and sort boss challenges
        local filtered_bosses = {}
        for _, spot in pairs(grouped_spots.boss_challenges) do
            -- Only include entries ending with "_Boss" (filter out _Boss_Clear and _Boss_Portal)
            if string.match(spot, "_Boss$") then
                table.insert(filtered_bosses, spot)
            end
        end

        -- Sort by chapter number
        table.sort(filtered_bosses, function(a, b)
            local ch_a = tonumber(string.match(a, "DLC_BC_CH(%d+)_Boss"))
            local ch_b = tonumber(string.match(b, "DLC_BC_CH(%d+)_Boss"))
            return ch_a < ch_b
        end)

        Utils.Log(Ar, "=== BOSS CHALLENGES ===")
        Utils.Log(Ar, "Example: teleport_to <teleport_id>")
        Utils.Log(Ar, "========================")
        for _, spot in pairs(filtered_bosses) do
            -- Extract chapter number
            local chapter = tonumber(string.match(spot, "DLC_BC_CH(%d+)_Boss"))

            -- Get boss name if we have it, otherwise use generic format
            local boss_name = boss_names[chapter]
            if boss_name then
                Utils.Log(Ar, string.format("Chapter %d: %s: %s", chapter, boss_name, spot))
                -- Add warnings for problematic bosses
                if chapter == 14 then
                    Utils.Log(Ar, "        WARNING: Boss 14 not working unless specific game requirements met")
                elseif chapter == 17 then
                    Utils.Log(Ar,
                        "        WARNING: Need to have visited DLC_LD_Winter_Sea_Mansion_2F before teleport will work")
                    Utils.Log(Ar, "        Try: teleport_to DLC_LD_Winter_Sea_Mansion_2F")
                end
            else
                Utils.Log(Ar, string.format("Chapter %d: boss name: Unknown Boss teleport_id: %s", chapter, spot))
            end
        end
        Utils.Log(Ar, "========================")
    end
    return true
end

local function set_teleport_target(FullCommand, Parameters, Ar)
    local target = tostring(Parameters[1])
    ModGlobals.TeleportTarget = FName(target)
    Utils.Log(Ar, "Teleport target set to: " .. tostring(ModGlobals.TeleportTarget:ToString()))
    return true
end

local function set_souls_multiply(FullCommand, Parameters, Ar)
    if not Parameters[1] then
        Utils.Log(Ar, "Usage: set_souls_multiply <multiplier>")
        Utils.Log(Ar, "Example: set_souls_multiply 2.0")
        return true
    end
    local new_multiplier = tonumber(Parameters[1])

    if not new_multiplier then
        Utils.Log(Ar, "Invalid multiplier. Please enter a valid number.")
        return true
    end

    ModGlobals.SoulsMultiplier = new_multiplier


    print('SOULS MULTIPLIER SET TO::: ' .. tostring(ModGlobals.SoulsMultiplier))

    ---@class ALPCCharacter : ALCharacter
    local char = UEHelpers.GetPlayerController().Character
    ---@class ULCharacterSaveGame : ULSaveGame
    local save_game_data = char.PlayingGameData
    if save_game_data then
        local character_data = save_game_data.CharacterSaveData
        local p_souls = character_data.AcquisitionSoul
        print('SOULS BEFORE MULTIPLY::: ' .. tostring(p_souls))
        print("Souls after multiply::: " .. tostring(p_souls * ModGlobals.SoulsMultiplier))
    end

    return true
end

local function goto_boss(FullCommand, Parameters, Ar)
    -- Boss name mapping based on chapter order - matches list_boss_challenges
    local boss_names = {
        [1] = "Parade Master",
        [2] = "Scrapped Watchman",
        [3] = "Kings Flame, Fuoco",
        [4] = "Fallen Archbishop Andreus",
        [5] = "Eldest of the Black Rabbit Brotherhood",
        [6] = "King of Puppets",
        [7] = "Champion Victor",
        [8] = "Green Monster of the Swamp",
        [9] = "Corrupted Parade Master",
        [11] = "Black Rabbit Brotherhood", --CH11 -- 10 is missing
        [12] = "Laxasia the Complete",     --CH12
        [13] = "Simon Manus, Arm of God",  --CH13
        [14] = "Nameless Puppet",          --CH14 -- NOT WORKING  - Can't trigger yet - even with humanity + 99 when refusing to give heart
        [15] = "Markiona, Puppeteer of Death",
        [16] = "Anguished Guardian of the Ruins",
        [17] = "Arlecchino the Blood Artist", -- need to have visited DLC_LD_Winter_Sea_Mansion_2F before the teleport will work
        [18] = "Two-faced Overseer",
    }

    -- Check if chapter parameter was provided
    if not Parameters[1] then
        Utils.Log(Ar, "Usage: goto_boss <chapter_number>")
        Utils.Log(Ar, "Example: goto_boss 1")
        Utils.Log(Ar, "Available chapters: 1-9, 11-18 (CH10 is missing)")
        list_boss_challenges(FullCommand, Parameters, Ar)
        return true
    end

    -- Convert parameter to number
    local chapter = tonumber(Parameters[1])

    -- Validate chapter number
    if not chapter or chapter < 1 or chapter > 18 or chapter == 10 then
        Utils.Log(Ar, "Invalid chapter number. Available chapters: 1-9, 11-18 (CH10 is missing)")
        return true
    end

    -- Build the boss location ID
    local boss_location = string.format("DLC_BC_CH%02d_Boss", chapter)

    -- Get boss name for feedback
    local boss_name = boss_names[chapter] or "Unknown Boss"

    -- Special warnings for problematic bosses
    if chapter == 14 then
        Utils.Log(Ar, "WARNING: Boss 14 not working unless specific game requirements met")
    elseif chapter == 17 then
        Utils.Log(Ar, "WARNING: Need to have visited DLC_LD_Winter_Sea_Mansion_2F before teleport will work")
        Utils.Log(Ar, "Try: teleport_to DLC_LD_Winter_Sea_Mansion_2F")
    end

    Utils.Log(Ar, string.format("Teleporting to Chapter %d: %s (%s)", chapter, boss_name, boss_location))

    -- Use the same teleportation logic as teleport_to
    local action_teleport_start = FindAllOf('BP_Action_Teleport_Start_C')
    if action_teleport_start then
        for _, bp in pairs(action_teleport_start) do
            local dlc_entry_target = FName(boss_location)
            bp.Payload.TeleportTarget = dlc_entry_target
            bp:Start()
            break
        end
    else
        Utils.Log(Ar,
            "No action teleport start found -- setting teleport target. please try to use pocket watch now to go to: " ..
            boss_location)
        ModGlobals.SetTeleportTarget(boss_location)
    end

    return true
end

local function set_hair_color(FullCommand, Parameters, Ar)
    if not Parameters[1] then
        Utils.Log(Ar, "Usage: set_hair_color <color_number>")
        Utils.Log(Ar, "Available colors:")
        Utils.Log(Ar, "0: Basic")
        Utils.Log(Ar, "1: Long")
        Utils.Log(Ar, "2: WLong")
        Utils.Log(Ar, "3: WBasic")
        Utils.Log(Ar, "4: Max")
        Utils.Log(Ar, "5: Default")
        return true
    end

    local color = tonumber(Parameters[1])
    local save_game_data = UEHelpers.GetPlayerController().Character.PlayingGameData
    if save_game_data then
        local character_data = save_game_data.CharacterSaveData

        -- colors
        ---@type ELHairCategoryType
        local ELHairCategoryType = {
            [0] = "E_HAIR_BASIC",
            [1] = "E_HAIR_LONG",
            [2] = "E_HAIR_WLONG",
            [3] = "E_HAIR_WBASIC",
            [4] = "E_MAX",
            [5] = "E_DEFAULT",
        }

        if save_game_data then
            Utils.Log(Ar, 'SAVE GAME DATA: ' .. tostring(save_game_data:GetFullName()))
            Utils.Log(Ar, 'Hair Color Before: ' .. tostring(ELHairCategoryType[character_data.HairCategoryType]))
            character_data.HairCategoryType = color
            Utils.Log(Ar, 'Hair Color After: ' .. tostring(ELHairCategoryType[character_data.HairCategoryType]))
            Utils.Log(Ar, "Save to title and reload game for the change to take effect")
        end
    end
    return true
end


RegisterConsoleCommandHandler("teleport_to", teleport_to)
RegisterConsoleCommandHandler("set_ng_plus_round", set_ng_plus_round)
RegisterConsoleCommandHandler("list_boss_challenges", list_boss_challenges)
RegisterConsoleCommandHandler("goto_boss", goto_boss)
RegisterConsoleCommandHandler("set_teleport_target", set_teleport_target)
RegisterConsoleCommandHandler("set_hair_color", set_hair_color)
RegisterConsoleCommandHandler("set_souls_multiply", set_souls_multiply)
