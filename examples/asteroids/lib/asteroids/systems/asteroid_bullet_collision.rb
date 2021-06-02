class Asteroids::AsteroidBulletCollisionSystem < Gamey::System
    ASTEROID_COMPONENT_MASK = Asteroids::AsteroidComponent.mask |
                              Asteroids::TransformComponent.mask |
                              Asteroids::AABBComponent.mask

    BULLET_COMPONENT_MASK = Asteroids::BulletComponent.mask |
                            Asteroids::TransformComponent.mask |
                            Asteroids::AABBComponent.mask

    SCORE_PER_ASTROID = 10
    
    def update(dt)
        player = entities_with_components(Asteroids::PlayerComponent.mask).first
        return unless player

        player_c = player.component(Asteroids::PlayerComponent)
        return unless player_c.alive

        asteroids = entities_with_components(ASTEROID_COMPONENT_MASK)
        bullets = entities_with_components(BULLET_COMPONENT_MASK)        

        asteroids.each do |asteroid|
            bullets.each do |bullet|
                if check_and_resolve_collision(asteroid, bullet)
                    player_c.score += SCORE_PER_ASTROID
                    game.assets.sound('asteroid_hit.wav').play(0.5)
                end
            end
        end
    end

    private

    def check_and_resolve_collision(asteroid, bullet)
        asteroid_c = asteroid.component(Asteroids::AsteroidComponent)
        asteroid_aabb = asteroid.component(Asteroids::AABBComponent).aabb
        bullet_aabb = bullet.component(Asteroids::AABBComponent).aabb

        if bullet_aabb.intersects?(asteroid_aabb)
            bullet.destroy
            asteroid.destroy

            unless asteroid_c.small
                asteroid_pos = asteroid.component(Asteroids::TransformComponent).position

                3.times do
                    spawn_small(asteroid_pos)
                end
            end

            return true
        end
    end

    def spawn_small(pos)
        image_c = Asteroids::ImageComponent.new
        image_c.image = game.assets.image('asteroid_small.png')

        transform = Asteroids::TransformComponent.new
        transform.rotation = Gamey::Angle.in_degrees(rand(0..360))
        transform.position = pos
        
        velocity = Asteroids::VelocityComponent.new
        velocity.linear_velocity = (Gamey::Vector2.new(0, 1) * rand(50..150)).rotate(Gamey::Angle.in_degrees(rand(0..360)))
        velocity.angular_velocity = rand(-90..90)

        aabb_c = Asteroids::AABBComponent.new
        aabb_c.aabb = Gamey::AABB.new( transform.position, image_c.image.size )

        asteroid_c = Asteroids::AsteroidComponent.new
        asteroid_c.small = true

        asteroid = scene.new_entity
        asteroid.add_component image_c
        asteroid.add_component transform
        asteroid.add_component velocity
        asteroid.add_component aabb_c
        asteroid.add_component asteroid_c
    end
end