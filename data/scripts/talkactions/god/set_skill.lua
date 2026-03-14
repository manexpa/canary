local setSkill = TalkAction("/setskill")

function setSkill.onSay(player, words, param)
    if player:getGroup():getId() < 3 then return true end

    -- Formato: Nombre, Skill, Valor
    local split = param:split(",")
    if #split < 3 then
        player:sendCancelMessage("Usage: /setskill <player name>, <Skill>, <skill level>")
        player:sendTextMessage(MESSAGE_STATUS_CONSOLE_BLUE, "Skills: level, magic, fist, sword, axe, club, distance, shield, fishing")
        return true
    end

    local target = Player(split[1]:trim())
    local skillName = split[2]:trim():lower()
    local value = tonumber(split[3]:trim())

    if not target or not value or value < 1 then
        player:sendCancelMessage("Player offline or unexistent.")
        return true
    end

    if skillName == "level" then
        local currentExp = target:getExperience()
        local targetExp = Game.getExperienceForLevel(value)
        
        if targetExp > currentExp then
            target:addExperience(targetExp - currentExp, false)
        else
            target:removeExperience(currentExp - targetExp, false)
        end

        local vocation = target:getVocation()
        local multiplier = math.max(0, value - 8)
        target:setMaxHealth((multiplier * vocation:getHealthGain()) + 185)
        target:setMaxMana((multiplier * vocation:getManaGain()) + 35)
        target:setCapacity(((multiplier * (vocation:getCapacityGain() / 100)) + 400) * 100)
        target:addHealth(target:getMaxHealth())
        target:addMana(target:getMaxMana())
        
    else
        local skillMap = {
            ["magic"] = "mag", ["fist"] = SKILL_FIST, ["sword"] = SKILL_SWORD, ["axe"] = SKILL_AXE, 
            ["club"] = SKILL_CLUB, ["distance"] = SKILL_DISTANCE, 
            ["shield"] = SKILL_SHIELD, ["fishing"] = SKILL_FISHING
        }

        local skillId = skillMap[skillName]
        if not skillId then
            player:sendCancelMessage("Skill '" .. skillName .. "' unkown.")
            return true
        end

        if skillId == "mag" then
            target:setMagicLevel(value)
        else
            target:setSkillLevel(skillId, value)
        end
    end

    target:getPosition():sendMagicEffect(CONST_ME_MAGIC_GREEN)
    player:sendTextMessage(MESSAGE_EVENT_ADVANCE, "Skill '" .. skillName .. "' de " .. target:getName() .. " set to " .. value)
    return true
end

setSkill:groupType("god")
setSkill:separator(" ")
setSkill:register()
