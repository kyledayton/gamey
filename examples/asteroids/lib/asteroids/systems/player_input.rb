class Asteroids::PlayerInputSystem < Gamey::System
    COMPONENT_MASK = Asteroids::PlayerComponent.mask | 
                     Asteroids::TransformComponent.mask |
                     Asteroids::VelocityComponent.mask 
    
    ACCELERATION = 400
    MAX_VELOCITY = 600
    ROT_DEG_PER_SECOND = 180

    def update(dt)
        move = get_move
        
        entities_with_components(COMPONENT_MASK) do |e|
            transform = e.component(Asteroids::TransformComponent)
            vel_c = e.component(Asteroids::VelocityComponent)
            player = e.component(Asteroids::PlayerComponent)
            vel = vel_c.linear_velocity

            if move.x != 0
                rotation = transform.rotation + Gamey::Angle.in_degrees( ROT_DEG_PER_SECOND * move.x * dt )
                transform.rotation = rotation
            end

            if move.y > 0
                move = Gamey::Vector2.new(0, -ACCELERATION * move.y * dt).rotate(transform.rotation)
                new_velocity = vel + move

                if new_velocity.length > MAX_VELOCITY
                    new_velocity = new_velocity.unit * MAX_VELOCITY
                end

                vel_c.linear_velocity = new_velocity

                play_sound(player)
            else
                stop_sound(player)
            end

            if game.input.action(:shoot).just_pressed?
                player.did_shoot = true
            end
        end
    end

    private

    def get_move
        move = Gamey::Vector2.new

        move.y += 1 if game.input.action(:forward).pressed?
        move.x -= 1 if game.input.action(:left).pressed?
        move.x += 1 if game.input.action(:right).pressed?

        move
    end

    def play_sound(player)
        player.thrust_sound ||= game.assets.sound('thrust.wav').play(0.05, 1, true)

        unless player.thrust_sound.playing?
            player.thrust_sound.resume
        end
    end

    def stop_sound(player)
        if player.thrust_sound && player.thrust_sound.playing?
            player.thrust_sound.pause
        end
    end
end