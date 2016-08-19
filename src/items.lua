local Shield, Weapon, HitDamage = Component.load({"Shield", "Weapon", "HitDamage"})

items = {
    shield = {
        name = "Energy Shield",
        component = Shield,
        layer = 2,
        level = 2,
        image = resources.images.core2
    },
    laser = {
        name = "Cryo-Laser",
        component = function()
            return Weapon({
                type = 'laser',
                damage = 3,
                cooldown = 2,
                hitChance = .5,
                sprayAngle = 10,
                range = 150
            })
        end,
        layer = 3,
        level = 3,
        image = resources.images.eyes3
    },
    missiles = {
        name = "C4 Warheads",
        component = function()
            return Weapon({
                type = 'missile',
                damage = 40,
                cooldown = 4,
                hitChance = .5,
                sprayAngle = 10,
                range = 500
            })
        end,
        layer = 3,
        level = 4,
        image = resources.images.eyes2
    },
    ram = {
        name = "Battering Ram 2050 Edition",
        component = function()
            return HitDamage({
                frontal = 10,
                rear = 20,
                mothership = 10
            })
        end,
        layer = 3,
        level = 1,
        image = resources.images.eyes1
    }
}
