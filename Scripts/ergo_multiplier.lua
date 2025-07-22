local Utils = require("Utils.Utils")
local UEHelpers = require("UEHelpers.UEHelpers")
local ModGlobals = require("mod_globals")

local function register_func()
    RegisterHook('/Game/Blueprints/LevelObjectBP/BP_Ergo_Trail.BP_Ergo_Trail_C:SetErgoData', function(self, InData)
        local ergo_exp = InData:get().ErgoExp
        ---@class ULCharacterSaveGame : ULSaveGame
        local save_game_data = UEHelpers.GetPlayerController().Character.PlayingGameData

        if save_game_data then
            print('save data: ' .. tostring(save_game_data:GetFullName()))
            local character_data = save_game_data.CharacterSaveData
            local p_souls_2 = character_data.AcquisitionSoul + (ergo_exp * ModGlobals.SoulsMultiplier)
            character_data.AcquisitionSoul = p_souls_2
        end
    end)
end

ErgoMultiplierHookInverval = Utils.SetInterval(function()
    local does_class_exist = StaticFindObject('/Game/Blueprints/LevelObjectBP/BP_Ergo_Trail.BP_Ergo_Trail_C')

    local player = UEHelpers.GetPlayer()
    if not does_class_exist and not does_class_exist:IsValid() then
        print('Error registering hook for ergo multiplier: ' .. tostring(does_class_exist))
        print('Trying to register again...')
    else
        print('BP_Ergo_Trail.Default__BP_Ergo_Trail_C exists, registering hook...')
        register_func()
        Utils.ClearInterval(ErgoMultiplierHookInverval)
    end
end, 10)


