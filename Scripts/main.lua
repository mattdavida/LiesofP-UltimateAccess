UEHelpers = require("UEHelpers.UEHelpers")
Utils = require("Utils.Utils")
require("LuaReplDebug.LuaReplDebug")
local teleport_target = FName("")

-- ///////////////////////////////////////////////////////////////////////////////////////////////
-- KEYBINDS
-- ///////////////////////////////////////////////////////////////////////////////////////////////
local function teleport_to_dlc_start_area_from_pocketwatch()
    ---@class ULCharacterSaveGame : ULSaveGame
    local save_game_data = UEHelpers.GetPlayerController().Character.PlayingGameData
    print('SAVE GAME DATA: ' .. tostring(save_game_data:GetFullName()))
    ---@class FLSpotSaveData
    local spot_save_data = save_game_data.SpotSaveData

    ---@class UBP_Action_Teleport_Start_C : ULAction_LoopAnim
    local action_teleport_start = FindAllOf('BP_Action_Teleport_Start_C')
    if action_teleport_start then
        for _, bp in pairs(action_teleport_start) do
            local dlc_entry_target = FName("LD_OldTown_Pilgrimage")
            bp.Payload.TeleportTarget = dlc_entry_target
            -- LActPayload_Teleport - see current targets in live view
            bp:Start()
            break
        end
    end
end

local function give_dlc_key_item_start_ng_10()
    local save_game_data = UEHelpers.GetPlayerController().Character.PlayingGameData
    if save_game_data then
        local character_data = save_game_data.CharacterSaveData

        -- give dlc item? seems to work
        character_data.NewGamePlus_Round = 10
        -- character_data.NewGamePlus_Round_DLC = 10
        print("SAVE DATA AFTER: " .. tostring(save_game_data:GetFullName()))
    end
end

local function give_dlc_key_item_start_base_game()
    local save_game_data = UEHelpers.GetPlayerController().Character.PlayingGameData
    if save_game_data then
        local character_data = save_game_data.CharacterSaveData

        -- give dlc item? seems to work
        character_data.NewGamePlus_Round = 1
        character_data.NewGamePlus_Round_DLC = 1
        print("SAVE DATA AFTER: " .. tostring(save_game_data:GetFullName()))
    end
end

local function give_dlc_reward_items()
    local save_game_data = UEHelpers.GetPlayerController().Character.PlayingGameData
    if save_game_data then
        local character_data = save_game_data.CharacterSaveData

        character_data.ShowEnding_DLC = true
        print("SAVE DATA: " .. tostring(save_game_data:GetFullName()))
    end
end


function get_teleport_spots()
    local save_game_data = UEHelpers.GetPlayerController().Character.PlayingGameData
    if save_game_data then
        local character_data = save_game_data.CharacterSaveData
        local spots = {}

        local teleport_object_info_asset = FindAllOf('TeleportObjectInfoAsset')
        if teleport_object_info_asset then
            for _, tp in pairs(teleport_object_info_asset) do
                local teleport_object_array = tp.ContentInfoDB._TeleportObject_array
                if teleport_object_array then
                    for i = 1, teleport_object_array:GetArrayNum() do
                        local teleport_object = teleport_object_array[i]
                        table.insert(spots, teleport_object._code_name:ToString())
                    end
                end
            end
            return spots
        end
        return nil
    end
end

local function group_teleport_spots(spots)
    local grouped = {
        test_locations = {},
        base_game = {
            hotel = {},
            station = {},
            boutique = {},
            town_hall = {},
            factory = {},
            cathedral = {},
            old_town = {},
            culture_street = {},
            arcade = {},
            exhibition_hall = {},
            puppet_grave = {},
            underdark = {},
            monastery = {}
        },
        dlc_content = {
            zoo = {},
            deserted_hotel = {},
            underground_lab = {},
            underground_ruin = {},
            winter_sea = {},
            special_hotels = {}
        },
        boss_challenges = {
            -- CH01-CH18 representing chronological boss order from base game
        },
        uncategorized = {}
    }

    for _, spot in pairs(spots) do
        local categorized = false

        -- Test locations
        if string.match(spot, "^[Tt]est_") then
            table.insert(grouped.test_locations, spot)
            categorized = true

            -- Boss challenges (separate from other DLC content)
        elseif string.match(spot, "^DLC_BC_CH%d+_") then
            table.insert(grouped.boss_challenges, spot)
            categorized = true

            -- Base game locations
        elseif string.match(spot, "^LD_Hotel_") then
            table.insert(grouped.base_game.hotel, spot)
            categorized = true
        elseif string.match(spot, "^LD_Station_") then
            table.insert(grouped.base_game.station, spot)
            categorized = true
        elseif string.match(spot, "^LD_Boutique_") then
            table.insert(grouped.base_game.boutique, spot)
            categorized = true
        elseif string.match(spot, "^LD_TownHall_") then
            table.insert(grouped.base_game.town_hall, spot)
            categorized = true
        elseif string.match(spot, "^LD_Factory_") then
            table.insert(grouped.base_game.factory, spot)
            categorized = true
        elseif string.match(spot, "^LD_Cathrdal_") then
            table.insert(grouped.base_game.cathedral, spot)
            categorized = true
        elseif string.match(spot, "^LD_OldTown_") then
            table.insert(grouped.base_game.old_town, spot)
            categorized = true
        elseif string.match(spot, "^LD_CultureStreet_") then
            table.insert(grouped.base_game.culture_street, spot)
            categorized = true
        elseif string.match(spot, "^LD_Arcade_") then
            table.insert(grouped.base_game.arcade, spot)
            categorized = true
        elseif string.match(spot, "^LD_ExhibitionHall_") then
            table.insert(grouped.base_game.exhibition_hall, spot)
            categorized = true
        elseif string.match(spot, "^LD_Puppet_Grave_") then
            table.insert(grouped.base_game.puppet_grave, spot)
            categorized = true
        elseif string.match(spot, "^LD_Underdark_") then
            table.insert(grouped.base_game.underdark, spot)
            categorized = true
        elseif string.match(spot, "^LD_Monastery_") then
            table.insert(grouped.base_game.monastery, spot)
            categorized = true

            -- DLC locations (excluding boss challenges)
        elseif string.match(spot, "^DLC_LD_Krat_Zoo_") then
            table.insert(grouped.dlc_content.zoo, spot)
            categorized = true
        elseif string.match(spot, "^DLC_LD_Deserted_Hotel_") then
            table.insert(grouped.dlc_content.deserted_hotel, spot)
            categorized = true
        elseif string.match(spot, "^DLC_LD_Underground_Lab_") then
            table.insert(grouped.dlc_content.underground_lab, spot)
            categorized = true
        elseif string.match(spot, "^DLC_LD_Underground_Ruin_") then
            table.insert(grouped.dlc_content.underground_ruin, spot)
            categorized = true
        elseif string.match(spot, "^DLC_LD_Winter_Sea_") then
            table.insert(grouped.dlc_content.winter_sea, spot)
            categorized = true
        elseif string.match(spot, "^DLC_LD_.*Hotel$") then
            table.insert(grouped.dlc_content.special_hotels, spot)
            categorized = true
        end

        -- If not categorized, add to uncategorized
        if not categorized then
            table.insert(grouped.uncategorized, spot)
        end
    end

    return grouped
end


local function write_file_teleport_spots_for_pocket_watch()
    local spots = get_teleport_spots()
    if spots then
        local grouped_spots = group_teleport_spots(spots)

        -- Write to file

        -- ex: "C:\Program Files (x86)\Steam\steamapps\common\Lies of P\LiesofP\Binaries\Win64\teleport_locations.txt"
        local file, err = io.open("teleport_locations.txt", "w")
        if not file then
            print("❌ ERROR: Could not create teleport_locations.txt - " .. tostring(err))
            return
        end
        print('Writing to file: ' ..
            'C:\\Program Files (x86)\\Steam\\steamapps\\common\\Lies of P\\LiesofP\\Binaries\\Win64\\teleport_locations.txt')
        -- Write header and usage instructions
        file:write("LIES OF P - POCKET WATCH TELEPORT LOCATIONS\n")
        file:write("=" .. string.rep("=", 50) .. "\n\n")
        file:write("USAGE:\n")
        file:write("In UE4SS console, type:\n")
        file:write("set_pocket_watch_teleport_location('<location_name>')\n\n")
        file:write("EXAMPLES:\n")
        file:write("set_pocket_watch_teleport_location('DLC_LD_Winter_Sea_WreckedShip_Portal')\n")
        file:write("set_pocket_watch_teleport_location('LD_Hotel_Main')\n")
        file:write("set_pocket_watch_teleport_location('DLC_LD_Krat_Zoo_FirstEntry')\n\n")

        -- Count locations
        local base_count = 0
        local dlc_count = 0
        local boss_count = #grouped_spots.boss_challenges
        for _, locations in pairs(grouped_spots.base_game) do
            base_count = base_count + #locations
        end
        for _, locations in pairs(grouped_spots.dlc_content) do
            dlc_count = dlc_count + #locations
        end

        file:write(string.format("SUMMARY: %d Base Game + %d DLC + %d Boss Challenges = %d Total Locations\n\n",
            base_count, dlc_count, boss_count, base_count + dlc_count + boss_count))

        -- Write base game locations
        file:write("BASE GAME LOCATIONS:\n")
        file:write(string.rep("-", 25) .. "\n")
        for area_name, locations in pairs(grouped_spots.base_game) do
            if #locations > 0 then
                file:write(string.format("\n%s (%d locations):\n", area_name:upper(), #locations))
                for _, spot in pairs(locations) do
                    file:write("  • " .. spot .. "\n")
                end
            end
        end

        -- Write DLC locations
        file:write("\n\nDLC LOCATIONS:\n")
        file:write(string.rep("-", 15) .. "\n")
        for area_name, locations in pairs(grouped_spots.dlc_content) do
            if #locations > 0 then
                file:write(string.format("\n%s (%d locations):\n", area_name:upper(), #locations))
                for _, spot in pairs(locations) do
                    file:write("  • " .. spot .. "\n")
                end
            end
        end

        -- Write boss challenges
        file:write("\n\nBOSS CHALLENGES:\n")
        file:write(string.rep("-", 17) .. "\n")
        file:write("(Chronological order from Chapter 1 to Chapter 18)\n")
        if #grouped_spots.boss_challenges > 0 then
            for _, spot in pairs(grouped_spots.boss_challenges) do
                file:write("  • " .. spot .. "\n")
            end
        end

        -- Write search tips
        file:write("\n\nSEARCH TIPS:\n")
        file:write(string.rep("-", 12) .. "\n")
        file:write("Look for these patterns:\n")
        file:write("  Boss Fights: *BossRoom*, *Boss*\n")
        file:write("  Entry Points: *Enter*, *Enterance*\n")
        file:write("  Fast Travel: *Portal*\n")
        file:write("  Main Areas: *Main*, *S*\n")
        file:write("  DLC Content: DLC_*\n")
        file:write("  Specific Areas: *Hotel*, *Station*, *Zoo*, *Winter_Sea*\n")

        file:write("\n\nGenerated: " .. os.date("%Y-%m-%d %H:%M:%S") .. "\n")
        file:close()

        print("✅ Teleport locations written to teleport_locations.txt")
        print("📁 File contains " .. (base_count + dlc_count + boss_count) .. " total locations")
        print("🏛️ Base Game: " .. base_count .. " | 🎮 DLC: " .. dlc_count .. " | 👑 Boss Challenges: " .. boss_count)
        print("💡 Open the file to browse available teleport targets for use with the tele port_to")
    end
end



local function set_humanity_to_max(FullCommand, Parameters, Ar)
    local save_game_data = UEHelpers.GetPlayerController().Character.PlayingGameData
    if save_game_data then
        local character_data = save_game_data.CharacterSaveData
        character_data.HumanityLevel = 10
        character_data.AcquisitionHumanity = 99999
        Utils.Log(Ar, "Humanity set to max. save to title and reload game for the change to take effect")
    end
    return true
end

-- first get pocket watch - activate first stargazer - use pocket watch - then press f2
-- if you used f3 first to get dlc item - the dlc butterfly sequence will play and the
-- dlc stargazer will be activated -
RegisterKeyBind(Key.F2, {}, teleport_to_dlc_start_area_from_pocketwatch)
-- need to first set value to 10 -- save to title - reload game - get dlc item
RegisterKeyBind(Key.F3, {}, give_dlc_key_item_start_ng_10)
-- then  set value to 1 - save to title - reload game - get no ng 10
RegisterKeyBind(Key.F4, {}, give_dlc_key_item_start_base_game)
-- get Monad's sword to play through game from start - run cmd - get item
RegisterKeyBind(Key.F5, {}, give_dlc_reward_items)
RegisterKeyBind(Key.F6, {}, write_file_teleport_spots_for_pocket_watch)
RegisterKeyBind(Key.F7, {}, set_humanity_to_max)

-- ///////////////////////////////////////////////////////////////////////////////////////////////
-- GLOBAL FUNCTIONS
-- ///////////////////////////////////////////////////////////////////////////////////////////////
function TeleportTo(destination)
    print("Teleporting to " .. tostring(destination))
    local location = tostring(destination)
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
        print("No action teleport start found -- travel to most recent stargazer with pocket watch first")
    end
end

function SetTeleportTarget(target)
    teleport_target = FName(target)
    print("Teleport target set to: " .. tostring(teleport_target:ToString()))
end

function GetGroupedTeleportSpots()
    local spots = get_teleport_spots()
    if spots then
        return group_teleport_spots(spots)
    end
    return nil
end

-- ///////////////////////////////////////////////////////////////////////////////////////////////
-- CONSOLE COMMANDS
-- ///////////////////////////////////////////////////////////////////////////////////////////////
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
        SetTeleportTarget(location)
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
        [14] = "Nameless Puppet",          --CH14 -- Puppet Master -- NOT WORKING  - Can't trigger yet - even with humanity + 99 when refusing to give heart
        [15] = "Markiona, Puppeteer of Death",
        [16] = "Anguished Guardian of the Ruins",
        [17] = "Arlecchino the Blood Artist", -- need to have visited DLC_LD_Winter_Sea_Mansion_2F before the teleport will work
        [18] = "Two-faced Overseer",
    }

    local spots = get_teleport_spots()

    if spots then
        local grouped_spots = group_teleport_spots(spots)

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
    teleport_target = FName(target)
    Utils.Log(Ar, "Teleport target set to: " .. tostring(teleport_target:ToString()))
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
        SetTeleportTarget(boss_location)
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


-- ///////////////////////////////////////////////////////////////////////////////////////////////
-- HOOKS -- THESE REALLY NEED TO BE SET CONDITIONALLY -- CURRENTLY ERRORS ON START AND YOU MUST
--       -- REFRESH THE MOD TO GET THEM TO WORK AFTER GAME START
-- ///////////////////////////////////////////////////////////////////////////////////////////////
RegisterHook("/Game/Blueprints/ActionBP/BP_Action_Teleport_Start.BP_Action_Teleport_Start_C:OnStart", function(self)
    if teleport_target ~= FName("") then
        print("🎯 Pocket watch teleport intercepted -- ORIGINAL TARGET: " ..
            tostring(self['As LAct Payload Teleport'].Payload.TeleportTarget:ToString()))
        local new_target = teleport_target
        self['As LAct Payload Teleport'].Payload.TeleportTarget = new_target
        print("🎯 Pocket watch teleport intercepted -- NEW TARGET: " ..
            tostring(self['As LAct Payload Teleport'].Payload.TeleportTarget:ToString()))
    end
end)

RegisterHook("/Game/Blueprints/ActionBP/BP_Action_Teleport_Start.BP_Action_Teleport_Start_C:OnStop", function(self)
    print("🎯 Pocket watch teleport intercepted -- ENDING")
    teleport_target = FName("")
end)
