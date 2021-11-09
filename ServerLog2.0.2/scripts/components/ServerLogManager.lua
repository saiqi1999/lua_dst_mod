local Constants = require("ServerLogger/Constants")
local Util = require("ServerLogger/Util")
local MAX_NUM = 4
local ServerLogManager = Class(function (self, inst)
    self.inst = inst
    self.buffs = {}
    self.netBuffs = net_string(inst.GUID, "buffs", "buffsChanged")
    self.onBuffsChanged = nil

    if TheNet:GetIsServer() then
        print("is server")
        inst:ListenForEvent("death", function ()
            self:ClearBuffs()
        end, inst)
        print("manager itself calling for set on buff changed")
        self:SetOnBuffsChanged1(function ()
            self.netBuffs:set(json.encode(self.buffs))
        end)
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

    local index = buff.index
    local buffObject = {
        str = buff.str,
    }

    local count = 0;
    for _ in pairs(self.buffs) do count = count + 1 end
    if count >= MAX_NUM then
        for i = 1, MAX_NUM-1 do
            print(i)
            print(self.buffs[i])
            self.buffs[i] = self.buffs[i+1]
        end
        self.buffs[MAX_NUM] = buffObject
    else
        self.buffs[index] = buffObject
    end
  

    self:BuffsChanged1()
    
end
function ServerLogManager:BuffsChanged1()
    if self.onBuffsChanged then
        self.onBuffsChanged(self.buffs)
    end
end

function ServerLogManager:ClearBuffs()
    self.buffs = {}
    self:BuffsChanged()
end



function ServerLogManager:GetBuffs()
    print("get buffs")
    return self.buffs
end

function ServerLogManager:SetBuffsFromNet()
    self.buffs = json.decode(self.netBuffs:value())
    self:BuffsChanged1()
end

function ServerLogManager:SetOnBuffsChanged1(onBuffsChanged)
    print("set on buff changed")
    self.onBuffsChanged = onBuffsChanged
end

return ServerLogManager
