modimport("scripts/protect.lua")

local Root = require("ServerLogger/widgets/Root")
local testStr = 1
local r

require("constants")
require("json")

AddClassPostConstruct("widgets/controls", function (controls)
    controls.inst:DoTaskInTime(0, function ()
        r = Root(GLOBAL.ThePlayer.player_classified.components.ServerLogManager)
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

local show = true
GLOBAL.TheInput:AddKeyUpHandler(122,function()
    if GLOBAL.TheFrontEnd:GetActiveScreen().name == "HUD" then
        if show then 
            GLOBAL.ThePlayer.components.talker:Say("hide") 
            r:SwitchVisibility()
            show = false
        else 
            GLOBAL.ThePlayer.components.talker:Say("show") 
            r:SwitchVisibility()
            show = true
        end
    end
end)