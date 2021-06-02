class Asteroids::AsteroidDespawnSystem < Gamey::System
    COMPONENT_MASK = Asteroids::AsteroidComponent.mask |
                     Asteroids::TransformComponent.mask

    def update(dt)
        player = entities_with_components(Asteroids::PlayerComponent.mask | Asteroids::TransformComponent.mask).first
        return unless player
        
        player_pos = player.component(Asteroids::TransformComponent).position

        entities_with_components(COMPONENT_MASK) do |e|
            pos = e.component(Asteroids::TransformComponent).position

            if (player_pos - pos).length > 1000
                e.destroy
            end
        end
    end
end