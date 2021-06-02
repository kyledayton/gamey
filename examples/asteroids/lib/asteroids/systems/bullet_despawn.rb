class Asteroids::BulletDespawnSystem < Gamey::System
    COMPONENT_MASK = Asteroids::BulletComponent.mask

    BULLET_TTL = 1 # seconds

    def update(dt)
        entities_with_components(COMPONENT_MASK) do |e|
            bullet = e.component(Asteroids::BulletComponent)

            bullet.timer.update(dt)

            if bullet.timer.elapsed >= BULLET_TTL
                e.destroy
            end
        end
    end
end