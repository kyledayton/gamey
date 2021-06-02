class Asteroids::AsteroidSpawnSystem < Gamey::System
    SPAWN_RANGE = 0.5..4 # Seconds

    def update(dt)
        @timer ||= Gamey::Timer.new
        @timer.update(dt)

        @next_spawn ||= rand(SPAWN_RANGE)

        if @timer.elapsed >= @next_spawn
            spawn
            @timer.reset
            @next_spawn = rand(SPAWN_RANGE)
        end
    end

    private

    def spawn
        player_ent = entities_with_components(Asteroids::PlayerComponent.mask | Asteroids::TransformComponent.mask).first
        return unless player_ent
        
        player_pos = player_ent.component(Asteroids::TransformComponent).position

        image_c = Asteroids::ImageComponent.new
        image_c.image = game.assets.image('asteroid.png')

        transform = Asteroids::TransformComponent.new
        transform.rotation = Gamey::Angle.in_degrees(rand(0..360))
        transform.position = spawn_pos
        
        velocity = Asteroids::VelocityComponent.new
        velocity.linear_velocity = ((player_pos - transform.position).unit * rand(50..250)).rotate(Gamey::Angle.in_degrees(rand(-45..45)))
        velocity.angular_velocity = rand(-90..90)

        aabb_c = Asteroids::AABBComponent.new
        aabb_c.aabb = Gamey::AABB.new( transform.position, image_c.image.size )

        asteroid = scene.new_entity
        asteroid.add_component image_c
        asteroid.add_component transform
        asteroid.add_component velocity
        asteroid.add_component aabb_c

        asteroid.add_component Asteroids::AsteroidComponent.new
    end

    def spawn_pos
        side = Gamey::Vector2.new
        
        if rand < 0.5
            side.x = -1
        else
            side.y = 1
        end

        if rand < 0.5
            side.y = -1
        else
            side.y = 1
        end

        x_offset = rand(64..80)
        y_offset = rand(64..80)
        pos = Gamey::Vector2.new

        if side.x < 0
            pos.x = -x_offset
        else
            pos.x = game.resolution[:width] + x_offset
        end
        
        if side.y < 0
            pos.y = -y_offset
        else
            pos.y = game.resolution[:height] + y_offset
        end

        pos
    end

end