local Constants = require("ServerLogger/Constants")
local Util = require("ServerLogger/Util")

local ServerLogManager = Class(function (self, inst)
    self.inst = inst
    self.buffs = {}
    self.netBuffs = net_string(inst.GUID, "buffs", "buffsChanged")
    self.onBuffsChanged = nil
    ------
    -- self.onStrChanged = nil
    -- self.strs = {}
    -- self.netStrs = net_string(inst.GUID,"strs","strChanged")
    ------

    if TheNet:GetIsServer() then
        print("is server")
        inst:ListenForEvent("death", function ()
            self:ClearBuffs()
        end, inst)
        print("manager itself calling for set on buff changed")
        self:SetOnBuffsChanged1(function ()
            self.netBuffs:set(json.encode(self.buffs))
        end)
        -- print("manager itself calling for set on str changed")
        -- self:SetOnStrChanged(function()
        --     self.netStrs:set(json.encode(self.strs))
        -- end)
    else
        inst:DoTaskInTime(0, function (inst)
            if ThePlayer.player_classified == inst then
                SendModRPCToServer(GetModRPC("ServerLog", "getStrs"), inst)
                inst:ListenForEvent("buffsChanged", function ()
                    self:SetBuffsFromNet()
                end, inst)
            end
        end)
    end
end)

function ServerLogManager:AddBuff(buff)
    -- print("add buff "..buff.type)
    -- local index = self:FindBuffIndex(buff.type)
    local index = buff.index
    local buffObject = {
        type = buff.type,
        -- duration = buff.duration,
        -- startedAt = GetTime(),
        str = buff.str,
    }

    -- if index == 0 then
    --     table.insert(self.buffs, buffObject)
    -- else
    self.buffs[index] = buffObject
    -- end

    self:BuffsChanged1()
    
end
--------
-- function ServerLogManager:ChangeStr(t)
--     print("on change")
--     local strObj = {
--         str = t.string,
--     }
--     self.strs[0] = strObj
--     print(self.strs[0].str)

--     self:StrChanged()
-- end
-- function ServerLogManager:StrChanged()
--     if self.onStrChanged then
--         self:onStrChanged(self.strs)
--     end
-- end
-- function ServerLogManager:SetOnStrChanged(onStrChanged)
--     print("set on str changed")
--     self.onStrChanged = onStrChanged
-- end
-- function ServerLogManager:GetStr()
--     print("get str")
--     return self.strs
-- end
--------
function ServerLogManager:BuffsChanged1()
    if self.onBuffsChanged then
        self.onBuffsChanged(self.buffs)
    end
end

function ServerLogManager:ClearBuffs()
    self.buffs = {}
    self:BuffsChanged()
end

-- function ServerLogManager:FindBuffIndex(buffType)
--     return Util:FindIndex(self.buffs, function (buff) return buff.type == buffType end)
-- end

function ServerLogManager:GetBuffs()
    print("get buffs")
    return self.buffs
end

-- function ServerLogManager:RemoveBuff(buffType)
--     local index = self:FindBuffIndex(buffType)

--     if index ~= 0 then
--         table.remove(self.buffs, index)

--         self:BuffsChanged1()
--     end
-- end

function ServerLogManager:SetBuffsFromNet()
    self.buffs = json.decode(self.netBuffs:value())
    self:BuffsChanged1()
    -- self.strs = json.decode(self.netStrs:value())
    -- self:StrChanged()
end

function ServerLogManager:SetOnBuffsChanged1(onBuffsChanged)
    print("set on buff changed")
    self.onBuffsChanged = onBuffsChanged
end

return ServerLogManager
