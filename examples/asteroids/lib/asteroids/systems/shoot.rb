class Asteroids::ShootSystem < Gamey::System
    COMPONENT_MASK = Asteroids::TransformComponent.mask |
                     Asteroids::PlayerComponent.mask

    SHOT_DELAY = 0.25 # seconds
    SHOT_VELOCITY = Gamey::Vector2.new(0, -800)

    def update(dt)
        entities_with_components(COMPONENT_MASK) do |e|
            player = e.component(Asteroids::PlayerComponent)
            transform = e.component(Asteroids::TransformComponent)

            player.shot_timer.update(dt)

            if player.did_shoot && player.shot_timer.elapsed >= SHOT_DELAY
                spawn_bullet(transform)
                game.assets.sound('shoot.wav').play(0.5)
                player.did_shoot = false
                player.shot_timer.reset
            end
        end
    end

    private

    def spawn_bullet(player_transform)
        transform = Asteroids::TransformComponent.new
        transform.position = player_transform.position

        vel = Asteroids::VelocityComponent.new
        vel.linear_velocity = SHOT_VELOCITY.rotate(player_transform.rotation)

        image_c = Asteroids::ImageComponent.new
        image_c.image = game.assets.image('bullet.png')

        aabb_c = Asteroids::AABBComponent.new
        aabb_c.aabb = Gamey::AABB.new( transform.position, image_c.image.size )

        ent = scene.new_entity
        ent.add_component Asteroids::BulletComponent.new
        ent.add_component transform
        ent.add_component vel
        ent.add_component image_c
        ent.add_component aabb_c
        ent.add_component Asteroids::OnScreenComponent.new
    end
end