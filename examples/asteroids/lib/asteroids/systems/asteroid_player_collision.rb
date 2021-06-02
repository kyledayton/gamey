class Asteroids::AsteroidPlayerCollisionSystem < Gamey::System
    ASTEROID_COMPONENT_MASK = Asteroids::AsteroidComponent.mask |
                              Asteroids::TransformComponent.mask |
                              Asteroids::AABBComponent.mask

    PLAYER_COMPONENT_MASK = Asteroids::PlayerComponent.mask |
                            Asteroids::TransformComponent.mask |
                            Asteroids::AABBComponent.mask

    def update(dt)
        player = entities_with_components(PLAYER_COMPONENT_MASK).first
        return unless player
        asteroids = entities_with_components(ASTEROID_COMPONENT_MASK)
       

        asteroids.each do |asteroid|
            check_and_resolve_collision(player, asteroid)
        end
    end

    private

    def check_and_resolve_collision(player, asteroid)
        asteroid_c = asteroid.component(Asteroids::AsteroidComponent)
        asteroid_aabb = asteroid.component(Asteroids::AABBComponent).aabb
        player_aabb = player.component(Asteroids::AABBComponent).aabb
        player_c = player.component(Asteroids::PlayerComponent)

        if player_c.alive && player_aabb.intersects?(asteroid_aabb)
            game.assets.sound('player_hit.wav').play
            player_c.thrust_sound.stop if player_c.thrust_sound
            player_c.alive = false
            player.remove_component Asteroids::ImageComponent
            player.remove_component Asteroids::TransformComponent
        end
    end
end