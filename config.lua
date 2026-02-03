---- APEX DEVELOPMENT 
-- DISCORD.GG/K3YnEJzzDA

Config = {}

Config.ProcessAmounts = {
    hashToKlump = {
        give = { { item='hashblade', amount=10 } },
        receive = { item='hash_klump', amount=10 },
        failChance = 0
    },
    klumpToPose = {
        give = { { item='hash_klump', amount=10 }, { item='plasticbag', amount=10 } },
        receive = { item='hash_pose', amount=10 },
        failChance = 0
    },
    klumpToJoint = {
        give = { { item='hash_klump', amount=10 }, { item='rolling_paper', amount=10 } },
        receive = { item='joint', amount=10 },
        failChance = 0
    },

    kokainToPulver = {
        give = { { item='kokainblade', amount=10 } },
        receive = { item='kokainpulver', amount=10 },
        failChance = 0
    },
    pulverToPose = {
        give = { { item='kokainpulver', amount=10 }, { item='plasticbag', amount=10 } },
        receive = { item='kokainpose', amount=10 },
        failChance = 0
    }
}

Config.ProcessLocations = {
    { label="Omdan hash", coords=vector3(-7.6426,-2498.9377,-8.9486), processType="hashToKlump" },
    { label="Pak hash", coords=vector3(-0.4132,-2497.7361,-8.6696), processType="klumpToPose" },
    { label="Rul joint", coords=vector3(-1.8697,-2499.7080,-8.6661), processType="klumpToJoint" }
}

Config.CokeProcessLocations = {
    { label="Kokain pulver", coords=vector3(1172.1544, -2972.8582, 6.3714), processType="kokainToPulver" },
    { label="Kokain pose", coords=vector3(1173.3629, -2972.6035, 6.2571), processType="pulverToPose" }
}
