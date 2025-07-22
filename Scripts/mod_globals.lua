-- Module for global variables and shared functions
local ModGlobals = {
    TeleportTarget = FName(""),
    SoulsMultiplier = 50.0
}

function ModGlobals.TeleportTo(destination)
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

function ModGlobals.SetTeleportTarget(target)
    ModGlobals.TeleportTarget = FName(target)
    print("Teleport target set to: " .. tostring(ModGlobals.TeleportTarget:ToString()))
end

function ModGlobals.GetGroupedTeleportSpots()
    -- This will be called after teleport module loads
    local TeleportApi = require("teleport")
    local spots = TeleportApi.get_teleport_spots()
    if spots then
        return TeleportApi.group_teleport_spots(spots)
    end
    return nil
end

-- Backward compatibility - expose functions globally for console commands
TeleportTo = ModGlobals.TeleportTo
SetTeleportTarget = ModGlobals.SetTeleportTarget
GetGroupedTeleportSpots = ModGlobals.GetGroupedTeleportSpots

return ModGlobals