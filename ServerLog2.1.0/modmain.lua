modimport("scripts/protect.lua")

local Root = require("ServerLogger/widgets/Root")
local testStr = 1

require("constants")
require("json")

AddClassPostConstruct("widgets/controls", function (controls)
    controls.inst:DoTaskInTime(0, function ()
        local r = Root(GLOBAL.ThePlayer.player_classified.components.ServerLogManager)
        if GetModConfigData("notice_pos") == 1 then r:SetPos(200) 
        else r:SetPos(800) end
        controls.serverLogger = controls.top_root:AddChild(r)
    end)
end)

AddModRPCHandler("ServerLog", "getStrs", function (player, inst)
    for k, v in ipairs(GLOBAL.AllPlayers)do
        if v and v.Network:IsServerAdmin() then
            if inst.components.ServerLogManager then
                local Manager = inst.components.ServerLogManager
                Manager.netNotices:set(GLOBAL.json.encode(Manager.notices) .. " ")
            end
        end
    end
    
end)

AddPrefabPostInit("player_classified", function (inst)
    inst:AddComponent("ServerLogManager")
end)