local setLevel = TalkAction("/setlevel")

function setLevel.onSay(player, words, param)
    if player:getGroup():getId() < 3 then 
        return true 
    end

    local split = param:split(",")
    if #split < 2 then
        player:sendCancelMessage("Usage: /setlevel <Player name>, <Level>")
        return true
    end

    local target = Player(split[1]:trim())
    local newLevel = tonumber(split[2]:trim())

    if not target then
        player:sendCancelMessage("Player offline or non-existent.")
        return true
    end

    if not newLevel or newLevel < 1 then
        player:sendCancelMessage("Invalid level.")
        return true
    end

    local vocation = target:getVocation()
    local startLevel = 8
    -- Valores base estándar de Tibia
    local baseHealth, baseMana, baseCap = 185, 35, 400 

    -- 1. Ajustar Experiencia
    local currentExp = target:getExperience()
    local targetExp = Game.getExperienceForLevel(newLevel)
    
    if targetExp > currentExp then
        target:addExperience(targetExp - currentExp, false)
    elseif targetExp < currentExp then
        target:removeExperience(currentExp - targetExp, false)
    end

    -- 2. calculate stats for the vocation
    local multiplier = math.max(0, newLevel - startLevel)
    
    local newMaxHealth = (multiplier * vocation:getHealthGain()) + baseHealth
    local newMaxMana = (multiplier * vocation:getManaGain()) + baseMana
    -- getCapacityGain returns the value in hundredths (e.g., 2000 for 20.00 oz)
    local newCap = (multiplier * (vocation:getCapacityGain() / 100)) + baseCap

    target:setMaxHealth(newMaxHealth)
    target:setMaxMana(newMaxMana)
    target:setCapacity(newCap * 100) -- internal format
    
    -- Curar al 100%
    target:addHealth(target:getMaxHealth())
    target:addMana(target:getMaxMana())

    target:getPosition():sendMagicEffect(CONST_ME_MAGIC_BLUE)
    player:sendTextMessage(MESSAGE_EVENT_ADVANCE, "Set level " .. newLevel .. " for " .. target:getName() .. " (HP/MP/Cap updated).")
    return true
end

setLevel:groupType("god")
setLevel:separator(" ")
setLevel:register()
