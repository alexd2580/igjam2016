local HasWeapon = Component.create("HasWeapon")

function HasWeapon:initialize()
    self.cooldown = 1.0
    self.since_last_fired = 0.0
end
