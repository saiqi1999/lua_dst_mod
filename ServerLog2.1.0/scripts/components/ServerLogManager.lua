local MAX_NUM = 4
local ServerLogManager = Class(function (self, inst)
    self.inst = inst
    self.notices = {}
    self.netNotices = net_string(inst.GUID, "notices", "noticed")
    self.afterTale = nil

    if TheNet:GetIsServer() then
        self:SetOnNoticesChanged(function ()
            self.netNotices:set(json.encode(self.notices))
        end)
    else
        inst:DoTaskInTime(0, function (inst)
            if ThePlayer.player_classified == inst then
                SendModRPCToServer(GetModRPC("ServerLog", "getStrs"), inst)
                inst:ListenForEvent("noticed", function ()
                    self:SetNoticesFromNet()
                end, inst)
            end
        end)
    end
end)

function ServerLogManager:AddBuffer(buffer)

    local index = buffer.index
    local bufferObject = {
        str = buffer.str,
    }

    local count = 0;
    for _ in pairs(self.notices) do count = count + 1 end
    if count >= MAX_NUM then
        for i = 1, MAX_NUM-1 do
            self.notices[i] = self.notices[i+1]
        end
        self.notices[MAX_NUM] = bufferObject
    else
        self.notices[index] = bufferObject
    end
  

    self:noticed()
    
end
function ServerLogManager:noticed()
    if self.afterTale then
        self.afterTale(self.notices)
    end
end

function ServerLogManager:ClearNotices()
    self.notices = {}
    self:noticed()
end



function ServerLogManager:GetNotices()
    return self.notices
end

function ServerLogManager:SetNoticesFromNet()
    self.notices = json.decode(self.netNotices:value())
    self:noticed()
end

function ServerLogManager:SetOnNoticesChanged(afterTale)
    self.afterTale = afterTale
end

return ServerLogManager
