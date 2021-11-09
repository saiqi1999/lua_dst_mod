
modimport("scripts/protect.lua")

if GetModConfigData("stack") then
    modimport("scripts/stack.lua")
end

if GetModConfigData("clean") then
     modimport("scripts/clean.lua")
end



local Root = require("ServerLogger/widgets/Root")
local Constants = require("ServerLogger/Constants")
local Util = require("ServerLogger/Util")
local testStr = 1

require("constants")
require("json")

AddClassPostConstruct("widgets/controls", function (controls)
    controls.inst:DoTaskInTime(0, function ()
        controls.serverLogger = controls.top_root:AddChild(Root(
            GLOBAL.ThePlayer.player_classified.components.ServerLogManager
            --GLOBAL.ThePlayer.player_classified.components.TimeDifferenceManager
        ))
    end)
    -- controls.inst:DoTaskInTime(0, function()
    --     controls.strSlot = controls.top_root:AddChild(MRoot(
    --         GLOBAL.ThePlayer.player_classified.components.ServerLoggingManager
    --     ))
    -- end)
end)

-- for prefab, buffType in pairs(Constants.BuffByPrefab) do
--     local onAttachBuff = function (inst, target)
--         local timeLeft = inst.components.timer:GetTimeLeft("buffover")
--         print("go in 1 index "..(testStr % 9 + 1))
--         local buffObject = {
--             index = testStr % 9 +1,
--             type = buffType,
--             -- duration = timeLeft,
--             str = testStr..buffType,
--         }
--         print(buffObject)
--         target.player_classified.components.ServerLogManager:AddBuff(buffObject)
--         ------go in
--         -- target.player_classified.components.ServerLoggingManager:AddS({
--         --     type = buffType,
--         --     duration = timeLeft,
--         --     str = testStr.."",
--         --     id = 1,
--         -- })
--         testStr = testStr+1
--         ------
--     end

--     AddPrefabPostInit("buff_" .. prefab, function (inst)
--         local onattachedfn = inst.components.debuff.onattachedfn
--         local onextendedfn = inst.components.debuff.onextendedfn
--         local ondetachedfn = inst.components.debuff.ondetachedfn
--         --entrance
--         inst.components.debuff:SetAttachedFn(function (inst, target, ...)
--             onattachedfn(inst, target, ...)
--             onAttachBuff(inst, target)
--         end)

--         inst.components.debuff:SetExtendedFn(function (inst, target, ...)
--             onextendedfn(inst, target, ...)
--             onAttachBuff(inst, target)
--         end)

--         inst.components.debuff:SetDetachedFn(function (inst, target, ...)
--             ondetachedfn(inst, target, ...)
--             -- target.player_classified.components.ServerLogManager:RemoveBuff(buffType)
--         end)
--     end)
-- end

-- all output from here?
AddModRPCHandler("ServerLog", "getStrs", function (player, inst)
    for k, v in ipairs(GLOBAL.AllPlayers)do
        if v and v.Network:IsServerAdmin() then
            if inst.components.ServerLogManager then
                local Manager = inst.components.ServerLogManager
                -- Manager.netStrs:set(GLOBAL.json.encode(Manager.strs) .. " ")
                -- " " because json could already be the same and nothing would be updated
                Manager.netBuffs:set(GLOBAL.json.encode(Manager.buffs) .. " ")
            end
        end
    end
    
end)
-- AddModRPCHandler("ServerLog","sendMessage",function(player,inst)
--     if inst.components.ServerLoggingManager ~= nil then
--         local ServerLoggingManager = inst.components.ServerLoggingManager
--         ServerLoggingManager.netStrs:set(GLOBAL.json.encode(ServerLoggingManager.strs).." ")
--     end
-- end)
-- AddPrefabPostInit("player_classified", function(inst)
--     inst.AddComponent("ServerLoggingManager")
-- end)
AddPrefabPostInit("player_classified", function (inst)
    inst:AddComponent("ServerLogManager")
    --inst:AddComponent("TimeDifferenceManager")
    --inst.AddComponent("ServerLogManager")
end)