common_string_warn = "Warning: "
common_string_hammer = " is Hammering "
common_string_light = " is lighting "
common_string_attack = " is attacking "
common_string_weapon = " with"
common_string_chop = " is chopping "
common_string_dig = " is digging "
common_string_pickup = " picked up " 
common_string_takeitem = " took "
common_string_castspell = " cast spell on"
common_string_comsumpt = " finished "
common_string_play = " is playing "
common_string_turnoff = " turned off "
common_string_harvest = " now harvesting"
common_string_mine = " now mining"
common_string_chop = " now chopping wood from "
common_string_pick = " now picking"
if GetModConfigData("lang") then 
    common_string_warn = "警告: "
    common_string_hammer = " 砸了 "
    common_string_light = " 点燃了 "
    common_string_attack = " 在打 "
    common_string_weapon = "--用"
    common_string_chop = " 在砍 "
    common_string_dig = " 在挖 "
    common_string_pickup = " 拾取了 " 
    common_string_takeitem = " 取走了 "
    common_string_castspell = " 施法 ->"
    common_string_comsumpt = " 解决了 "
    common_string_play = " 正在演奏 "
    common_string_turnoff = " 关闭了 "
    common_string_harvest = " 正在取食"
    common_string_mine = " 正在挖矿"
    common_string_chop = " 正在砍树 -> "
    common_string_pick = " 正在收作物"
end

local IsServer = GLOBAL.TheNet:GetIsServer() or GLOBAL.TheNet:IsDedicated()
local foodStatusLimit = 39
local testStr = 1
function sendString(string)

    if GetModConfigData("notice_method")==3 and IsServer then
        local bufferObject = {
            index = testStr,
            str = string,
        }
        -- print(bufferObject)
        for k, v in ipairs(GLOBAL.AllPlayers)do
            if v and v.Network:IsServerAdmin() then
                if v.player_classified.components.ServerLogManager then
                    v.player_classified.components.ServerLogManager:AddBuffer(bufferObject)
                end
            end
        end
        testStr = testStr + 1
    end

    if GetModConfigData("notice_method"==2) and IsServer then
        GLOBAL.TheNet:SystemMessage(string,true)
    end

    if GetModConfigData("notice_method"==1) and IsServer then
        GLOBAL.TheNet:Announce(string)
    end
end

local pickFlag = true;
function pik(inst)
    pickFlag = true;
end
local _ACTION_PICK = GLOBAL.ACTIONS.PICK.fn
GLOBAL.ACTIONS.PICK.fn = function(act)
    local obj = act.target or act.invobject
    if(obj ~= nil and act.doer ~= nil)then
        local msg = act.doer:GetDisplayName()..common_string_pick
        if GLOBAL.TheWorld.ismastersim and pickFlag then
            sendString(msg)
            pickFlag = false
            GLOBAL.TheWorld:DoTaskInTime(400,pik)
        end
    end
    if act.doer.userid then
        print(act.doer:GetDisplayName().."("..act.doer.userid..")"..common_string_pick..act.target:GetDisplayName())
    end
    return _ACTION_PICK(act)
end

local mineFlag = true;
function minn(inst)
    mineFlag = true;
end
local _ACTION_MINE = GLOBAL.ACTIONS.MINE.fn
GLOBAL.ACTIONS.MINE.fn = function(act)
    local obj = act.target or act.invobject
    if(obj ~= nil and act.doer ~= nil)then
        local msg = act.doer:GetDisplayName()..common_string_mine
        if GLOBAL.TheWorld.ismastersim and mineFlag then
            sendString(msg)
            mineFlag = false
            GLOBAL.TheWorld:DoTaskInTime(400,minn)
        end
    end
    if act.doer.userid then
        print(act.doer:GetDisplayName().."("..act.doer.userid..")"..common_string_mine..act.target:GetDisplayName())
    end
    return _ACTION_MINE(act)
end

local chopFlag = true;
function cho(inst)
    chopFlag = true;
end
local _ACTION_CHOP = GLOBAL.ACTIONS.CHOP.fn
GLOBAL.ACTIONS.CHOP.fn = function(act)
    local obj = act.target or act.invobject
    if(obj ~= nil and act.doer ~= nil)then
        local msg = act.doer:GetDisplayName()..common_string_chop..act.target:GetDisplayName()
        if GLOBAL.TheWorld.ismastersim and chopFlag then
            sendString(msg)
            chopFlag = false
            GLOBAL.TheWorld:DoTaskInTime(400,cho)
        end
    end
    if act.doer.userid then
        print(act.doer:GetDisplayName().."("..act.doer.userid..")"..common_string_chop..act.target:GetDisplayName())
    end
    return _ACTION_CHOP(act)
end

local harvestFlag = true;
function harv(inst)
    harvestFlag = true;
end
local _ACTION_HARVEST = GLOBAL.ACTIONS.HARVEST.fn
GLOBAL.ACTIONS.HARVEST.fn = function(act)
    local obj = act.target or act.invobject
    if(obj ~= nil and act.doer ~= nil)then
        local msg = act.doer:GetDisplayName()..common_string_harvest
        if GLOBAL.TheWorld.ismastersim and harvestFlag then
            sendString(msg)
            harvestFlag = false
            GLOBAL.TheWorld:DoTaskInTime(400,harv)
        end
    end
    if act.doer.userid then
        print(act.doer:GetDisplayName().."("..act.doer.userid..")"..common_string_harvest..act.target:GetDisplayName())
    end
    return _ACTION_HARVEST(act)
end



local _ACTION_TURNOFF = GLOBAL.ACTIONS.TURNOFF.fn
GLOBAL.ACTIONS.TURNOFF.fn = function(act)
    local obj = act.target or act.invobject
    if(obj ~= nil and obj.components.machine ~= nil)then
        local msg = act.doer:GetDisplayName()..common_string_turnoff..obj:GetDisplayName()
        sendString(msg)
       
    end
    if act.doer.userid then
        print(act.doer:GetDisplayName().."("..act.doer.userid..")"..common_string_turnoff..act.target:GetDisplayName())
    end
    return _ACTION_TURNOFF(act)
end

local _ACTION_PLAY = GLOBAL.ACTIONS.PLAY.fn
GLOBAL.ACTIONS.PLAY.fn = function(act)
    local obj = act.target or act.invobject
    if(obj ~= nil and obj.components.instrument ~= nil)then
        local msg = act.doer:GetDisplayName()..common_string_play..obj:GetDisplayName()
        sendString(msg)
       
    end
    if act.doer.userid then
        print(act.doer:GetDisplayName().."("..act.doer.userid..")"..common_string_play..obj:GetDisplayName())
    end
    return _ACTION_PLAY(act)
end

local _ACTION_EAT = GLOBAL.ACTIONS.EAT.fn
GLOBAL.ACTIONS.EAT.fn = function(act)
    local obj = act.target or act.invobject
    if(obj ~= nil and obj.components.edible ~= nil)then
        local calorie = obj.components.edible.hungervalue
        local heal = obj.components.edible.healthvalue
        local relax = obj.components.edible.sanityvalue
        if(calorie > foodStatusLimit or heal > foodStatusLimit or relax > foodStatusLimit)then
            local msg = act.doer:GetDisplayName()..common_string_comsumpt..obj:GetDisplayName()
            sendString(msg)
        end
    end
    return _ACTION_EAT(act)
end

local _ACTION_HAMMER = GLOBAL.ACTIONS.HAMMER.fn
GLOBAL.ACTIONS.HAMMER.fn = function(act)
    if act.doer and act.target and act.target.components.workable.workleft == 1 then
        local msg = act.doer:GetDisplayName()..common_string_hammer..act.target:GetDisplayName()
        sendString(msg)
       
        if act.doer.userid then
            print(act.doer:GetDisplayName().."("..act.doer.userid..")"..common_string_hammer..act.target:GetDisplayName())
        end
    end
    return _ACTION_HAMMER(act)
end

local _ACTION_LIGHT = GLOBAL.ACTIONS.LIGHT.fn
GLOBAL.ACTIONS.LIGHT.fn = function(act)
    if act.doer and act.target then
        local msg = act.doer:GetDisplayName()..common_string_light..act.target:GetDisplayName()
        sendString(msg)
       
        if act.doer.userid then
            print(act.doer:GetDisplayName().."("..act.doer.userid..")"..common_string_light..act.target:GetDisplayName())
        end
    end
    return _ACTION_LIGHT(act)
end


local displayDig = true
local _ACTION_DIG = GLOBAL.ACTIONS.DIG.fn
GLOBAL.ACTIONS.DIG.fn = function(act)
    if act.doer and act.target then
        local msg = act.doer:GetDisplayName()..common_string_dig..act.target:GetDisplayName()
        if GLOBAL.TheWorld.ismastersim and displayDig then
            sendString(msg)
            displayDig = false
            GLOBAL.TheWorld:DoTaskInTime(10,resetDisplayDig)
        end
        
        if act.doer.userid then
            print(act.doer:GetDisplayName().."("..act.doer.userid..")"..common_string_dig..act.target:GetDisplayName())
        end
    end
    return _ACTION_DIG(act)
end
function resetDisplayDig(inst)
    displayDig = true
end

local _ACTION_CASTSPELL = GLOBAL.ACTIONS.CASTSPELL.fn
GLOBAL.ACTIONS.CASTSPELL.fn = function(act)
    if act.doer and act.target then
        local staff = act.invobject or act.doer.components.inventory:GetEquippedItem(EQUIPSLOTS.HANDS)
        local s = " with something"
        if(staff~=nil)then
                s = tostring(staff)
                s, i = string.gsub(s,"%d","")
                s = string.gsub(s,"%(LIMBO%)","")
                s = string.gsub(s,"%-","")
        end
        local msg = act.doer:GetDisplayName()..common_string_castspell..act.target:GetDisplayName()..common_string_weapon..s
        sendString(msg)
        
        if act.doer.userid then
            print(act.doer:GetDisplayName().."("..act.doer.userid..")"..common_string_castspell..act.target:GetDisplayName())
        end
    elseif act.doer then
        if GLOBAL.TheWorld.ismastersim and IsServer then
            
            local staff = act.invobject or act.doer.components.inventory:GetEquippedItem(EQUIPSLOTS.HANDS)
                local s = tostring(staff)
                s, i = string.gsub(s,"%d","")
                s = string.gsub(s,"%(LIMBO%)","")
                s = string.gsub(s,"%-","")
            local msg = act.doer:GetDisplayName()..common_string_castspell .. common_string_weapon ..s
            sendString(msg)
            
        end
    end
    return _ACTION_CASTSPELL(act)
end

local displayPickup = true
local _ACTION_PICKUP = GLOBAL.ACTIONS.PICKUP.fn
GLOBAL.ACTIONS.PICKUP.fn = function(act)
    if act.doer and act.target then
        local msg = act.doer:GetDisplayName()..common_string_pickup..act.target:GetDisplayName()
        if GLOBAL.TheWorld.ismastersim and (act.target.components.teacher~=nil or act.target.components.equippable~=nil) then
            sendString(msg)
        elseif GLOBAL.TheWorld.ismastersim and displayPickup then
            sendString(msg)
            displayPickup = false
            GLOBAL.TheWorld:DoTaskInTime(15,resetDisplayPickup)
        end

        if act.doer.userid then
            print(act.doer:GetDisplayName().."("..act.doer.userid..")"..common_string_pickup..act.target:GetDisplayName())
        end
    end
    return _ACTION_PICKUP(act)
end
function resetDisplayPickup(inst)
    displayPickup = true
end

local display = true
local _ACTION_ATTACK = GLOBAL.ACTIONS.ATTACK.fn
GLOBAL.ACTIONS.ATTACK.fn = function(act)
    if act.doer and act.target then
        local msg = ""
        if GLOBAL.TheWorld.ismastersim  and display then
            local weapon = act.doer.components.combat:GetWeapon()
            if(weapon==nil)then
                msg = act.doer:GetDisplayName()..common_string_attack..act.target:GetDisplayName()
                sendString(msg)
                display = false
                GLOBAL.TheWorld:DoTaskInTime(15,seqi)
            elseif(weapon:HasTag("rangedweapon"))then
                local s = tostring(weapon)
                s, i = string.gsub(s,"%d","")
                s = string.gsub(s,"%(LIMBO%)","")
                s = string.gsub(s,"%-","")
                msg = act.doer:GetDisplayName()..common_string_attack..act.target:GetDisplayName()..common_string_weapon .. s
                sendString(msg)
                display = false
                GLOBAL.TheWorld:DoTaskInTime(15,seqi)
            else
                local s = tostring(weapon)
                s, i = string.gsub(s,"%d","")
                s = string.gsub(s,"%(LIMBO%)","")
                s = string.gsub(s,"%-","")
                msg = act.doer:GetDisplayName()..common_string_attack..act.target:GetDisplayName()..common_string_weapon .. s
                sendString(msg)
                display = false
                GLOBAL.TheWorld:DoTaskInTime(15,seqi)
            end
        end
       
        if act.doer.userid then
            print(act.doer:GetDisplayName().."("..act.doer.userid..")"..common_string_attack..act.target:GetDisplayName())
        end
    end
    return _ACTION_ATTACK(act)
end

function seqi(inst)
    display = true
end


