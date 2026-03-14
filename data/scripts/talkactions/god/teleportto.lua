local tpToPlace = TalkAction("/teleportto")

local destinations = {
    -- Towns
    ["thais"] = Position(32369, 32241, 7),
    ["venore"] = Position(32957, 32022, 6),
    ["carlin"] = Position(32360, 31782, 7),
    ["edron"] = Position(33213, 31819, 7),
    ["kazordoon"] = Position(32649, 31925, 11),
    ["darashia"] = Position(33213, 32454, 7),
    ["ankrahmun"] = Position(33194, 32853, 7),
    ["port hope"] = Position(32594, 32744, 7),
    ["liberty bay"] = Position(32317, 32826, 7),
    ["svargrond"] = Position(32212, 31132, 7),
    ["yalahar"] = Position(32787, 31276, 7),
    ["farmine"] = Position(33010, 31534, 10),
    ["rathleton"] = Position(33594, 31899, 7),
    ["gray island"] = Position(33447, 31323, 9),
    ["krailos"] = Position(33657, 32303, 7),
    ["issavi"] = Position(33921, 31464, 7),
    ["dawnport"] = Position(32065, 31891, 7),
    ["rookgaard"] = Position(32097, 32219, 7),

    -- QUESTS & BOSSES
    ["poi"] = Position(32813, 32258, 12),
    ["inquisition"] = Position(32788, 32276, 14),
    ["dhq"] = Position(33164, 31635, 13),
    ["anihi"] = Position(33221, 31659, 13), -- Lever room
    ["anihi sala"] = Position(33219, 31659, 13), -- Demon room
    ["paradox"] = Position(32477, 31903, 5),
    ["ferumbras"] = Position(33270, 32400, 14),
    ["morgaroth"] = Position(32817, 32559, 13),
    ["gazharagoth"] = Position(33605, 32420, 10),
    ["ghazbaran"] = Position(32040, 31034, 14),
    ["orshabaal"] = Position(32986, 31702, 10),
    ["desert"] = Position(32661, 32185, 9),
    ["vampire shield"] = Position(32688, 32259, 13),

    -- HUNT & OTHERS
    ["femor hills"] = Position(32535, 31837, 4),
    ["roshamuul"] = Position(33522, 32363, 7),
    ["oramond"] = Position(33538, 31881, 7),
    ["banuta"] = Position(32826, 32556, 7),
    ["behemoth"] = Position(32625, 31855, 12),
    ["demona"] = Position(32420, 31628, 15),
    ["mintwallin"] = Position(32431, 31988, 15),
    ["hellgate"] = Position(32675, 31644, 10),
    ["folda"] = Position(32047, 31582, 7),
    ["senja"] = Position(32125, 31667, 7),
    ["vega"] = Position(32027, 31692, 7),
    ["fibula"] = Position(32174, 32437, 7),
    ["gnomeregan"] = Position(32997, 31862, 9),
    ["ghostland"] = Position(32223, 31835, 7),
    ["draconia"] = Position(32803, 31587, 7),
    ["drefia"] = Position(32993, 32517, 7),
    ["okshol"] = Position(32194, 31393, 7), -- Tyrsung
    ["goroma"] = Position(32025, 32827, 7),
    ["tiquanda"] = Position(32800, 32500, 7),
    ["deep banuta"] = Position(32797, 32525, 14),
    ["asura palace"] = Position(32938, 32731, 7),
    ["walls"] = Position(33364, 31456, 1) -- Razachai
}

function tpToPlace.onSay(player, words, param)
    if player:getGroup():getId() < 3 then return true end

    local place = param:lower():trim()
    if place == "" then
        player:sendCancelMessage("Usage: /teleportto <place name>")
        return true
    end

    local destination = destinations[place]

    -- If not listed, search it as town
    if not destination then
        local t = Town(place)
        if t then
            destination = t:getTemplePosition()
        end
    end

    if not destination then
        player:sendCancelMessage("Place '" .. place .. "' is unkown.")
        return true
    end

    player:getPosition():sendMagicEffect(CONST_ME_TELEPORT)
    player:teleportTo(destination)
    destination:sendMagicEffect(CONST_ME_TELEPORT)
    player:sendTextMessage(MESSAGE_EVENT_ADVANCE, "Teleported to: " .. place:upper())
    return true
end

tpToPlace:groupType("god")
tpToPlace:separator(" ")
tpToPlace:register()
