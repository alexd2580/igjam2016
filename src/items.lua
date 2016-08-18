local Shield, Weapon = Component.load({"Shield", "Weapon"})

items = {
    shield = {
        name = "Shield",
        component = Shield,
        layer = 2,
        image = resources.images.core2
    },
    laser = {
        name = "Laser",
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
    }
}
