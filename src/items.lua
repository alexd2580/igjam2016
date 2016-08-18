local Shield, Weapon = Component.load({"Shield", "Weapon"})

items = {
    shield = {
        name = "Energy Shield",
        component = Shield,
        layer = 2,
        image = resources.images.core2
    },
    laser = {
        name = "Cryo-Laser",
        component = function()
            return Weapon({
                type = 'laser',
                damage = 2,
                cooldown = 2,
                hitChance = .5
            })
        end,
        layer = 3,
        image = resources.images.eyes3
    },
    missiles = {
        name = "C4 Warheads",
        component = function()
            return Weapon({
                type = 'missile',
                damage = 10,
                cooldown = 4,
                hitChance = 1
            })
        end,
        layer = 3,
        image = resources.images.eyes2
    }
}
