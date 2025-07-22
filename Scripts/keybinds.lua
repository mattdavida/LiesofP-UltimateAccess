local UEHelpers = require("UEHelpers.UEHelpers")
local TeleportApi = require("teleport")
local BetterJumps = require("better_jumps")
local ModGlobals = require("mod_globals")

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


local function set_humanity_to_max(FullCommand, Parameters, Ar)
    local save_game_data = UEHelpers.GetPlayerController().Character.PlayingGameData
    if save_game_data then
        local character_data = save_game_data.CharacterSaveData
        character_data.HumanityLevel = 10
        character_data.AcquisitionHumanity = 99999
    end
    return true
end

-- first get pocket watch - activate first stargazer - use pocket watch - then press f2
-- if you used f3 first to get dlc item - the dlc butterfly sequence will play and the
-- dlc stargazer will be activated -
RegisterKeyBind(Key.F2, {}, TeleportApi.teleport_to_dlc_start_area_from_pocketwatch)
-- need to first set value to 10 -- save to title - reload game - get dlc item
RegisterKeyBind(Key.F3, {}, give_dlc_key_item_start_ng_10)
-- then  set value to 1 - save to title - reload game - get no ng 10
RegisterKeyBind(Key.F4, {}, give_dlc_key_item_start_base_game)
-- get Monad's sword to play through game from start - run cmd - get item
RegisterKeyBind(Key.F5, {}, give_dlc_reward_items)
RegisterKeyBind(Key.F6, {}, TeleportApi.write_file_teleport_spots_for_pocket_watch)
RegisterKeyBind(Key.F7, {}, set_humanity_to_max)
RegisterKeyBind(Key.F8, {}, BetterJumps.SetBetterJumps)