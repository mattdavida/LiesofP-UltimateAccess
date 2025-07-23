local Utils = require("Utils.Utils")
local UEHelpers = require("UEHelpers.UEHelpers")
local ModGlobals = require("mod_globals")

local function register_func()
    RegisterHook("/Game/Blueprints/ActionBP/BP_Action_Teleport_Start.BP_Action_Teleport_Start_C:OnStart", function(self)
        if ModGlobals.TeleportTarget ~= FName("") then
            print("🎯 Pocket watch teleport intercepted -- ORIGINAL TARGET: " ..
                tostring(self['As LAct Payload Teleport'].Payload.TeleportTarget:ToString()))
            local new_target = ModGlobals.TeleportTarget
            self['As LAct Payload Teleport'].Payload.TeleportTarget = new_target
            print("🎯 Pocket watch teleport intercepted -- NEW TARGET: " ..
                tostring(self['As LAct Payload Teleport'].Payload.TeleportTarget:ToString()))
        end
    end)

    RegisterHook("/Game/Blueprints/ActionBP/BP_Action_Teleport_Start.BP_Action_Teleport_Start_C:OnStop", function(self)
        print("🎯 Pocket watch teleport intercepted -- ENDING")
        ModGlobals.TeleportTarget = FName("")
    end)
end


TeleportHookInverval = Utils.SetInterval(function()
    local does_class_exist = FindFirstOf('BP_Action_Teleport_Start_C')
    if not does_class_exist then
        print('Error registering hook for teleport: ' .. tostring(does_class_exist))
        print('Trying to register again...')
    else
        print('BP_Action_Teleport_Start.BP_Action_Teleport_Start_C exists, registering hook...')
        local success, error = pcall(register_func)
        if success then
            Utils.ClearInterval(TeleportHookInverval)
            print('Hook registered for teleport')
        else
            print('Failed to register hook: ')
        end
    end
    -- register hook 2 mins after game starts
end, 120)


local TeleportApi = {}

TeleportApi.teleport_to_dlc_start_area_from_pocketwatch = function()
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


TeleportApi.get_teleport_spots = function()
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

TeleportApi.group_teleport_spots = function(spots)
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

TeleportApi.write_file_teleport_spots_for_pocket_watch = function()
    local spots = TeleportApi.get_teleport_spots()
    if spots then
        local grouped_spots = TeleportApi.group_teleport_spots(spots)

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


return TeleportApi