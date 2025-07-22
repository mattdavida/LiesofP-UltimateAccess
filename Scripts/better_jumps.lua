local UEHelpers = require("UEHelpers.UEHelpers")

local BetterJumps = {}

local orig_scale = 1.6
local jump_scale = 4.8

function BetterJumps.SetBetterJumps()
    ---@class ACharacter : APawn
    local player = UEHelpers.GetPlayer()


    player.CharacterMovement.JumpZVelocity = 1000
    player.CharacterMovement.MaxAcceleration = 1000
    player.CharacterMovement.bForceMaxAccel = true

    -- found for both one and two hand only
    ---@class UAnimSequenceBase : UAnimationAsset
    local one_hand_rolling_anim = StaticFindObject(
        '/Game/ArtAsset/CH/PC/Pino/Animset/OneHand/Action/AS_Pino_O_Jump_Land_Rolling.AS_Pino_O_Jump_Land_Rolling')
    if one_hand_rolling_anim then
        one_hand_rolling_anim.SequenceLength = 0.5
    end
    ---@class UAnimSequenceBase : UAnimationAsset
    local two_hand_rolling_anim = StaticFindObject(
        '/Game/ArtAsset/CH/PC/Pino/Animset/TwoHand/Action/AS_Pino_O_Jump_Land_Rolling.AS_Pino_O_Jump_Land_Rolling')
    if two_hand_rolling_anim then
        two_hand_rolling_anim.SequenceLength = 0.5
    end

    RegisterHook('/Game/Blueprints/ActionBP/BP_Action_Jump.BP_Action_Jump_C:OnStart', function(self)
        player.CharacterMovement.GravityScale = jump_scale
    end)
    RegisterHook('/Game/Blueprints/ActionBP/BP_Action_Jump.BP_Action_Jump_C:OnStop', function(self)
        player.CharacterMovement.GravityScale = orig_scale
    end)

    local allMontages = FindAllOf('AnimMontage')
    if not allMontages then
        print('RUN COMMAND AGAIN WHEN PLAYER IS LOADED. NO MONTAGES FOUND')
        return
    end

    for _, montage in ipairs(allMontages) do
        local name = montage:GetFullName()
        ---@class UAnimSequenceBase : UAnimationAsset
        local m = montage
        -- Filter for PC/Pino animset AND jump/landing related animations
        if string.match(name, "PC/Pino/Animset") and
            (string.match(name, "Jump_Landing") or
                string.match(name, "MT_Landing") or
                string.match(name, "Fall_Landing")) then
            m.SequenceLength = 0.5
        end
    end
end

return BetterJumps
