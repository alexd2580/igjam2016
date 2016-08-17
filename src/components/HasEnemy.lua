local HasEnemy = Component.create("HasEnemy")

function HasEnemy:initialize(mothership)
    self.enemy_mothership = mothership
end
