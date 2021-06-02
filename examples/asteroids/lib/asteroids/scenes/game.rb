class Asteroids::GameScene < Gamey::Scene
    def setup
        add_system Asteroids::AsteroidSpawnSystem
        add_system Asteroids::AsteroidDespawnSystem
        add_system Asteroids::PlayerInputSystem
        add_system Asteroids::ShootSystem
        add_system Asteroids::BulletDespawnSystem
        add_system Asteroids::MovementSystem
        add_system Asteroids::AABBUpdateSystem
        add_system Asteroids::AsteroidBulletCollisionSystem
        add_system Asteroids::AsteroidPlayerCollisionSystem
        add_system Asteroids::OffScreenSystem
        add_system Asteroids::RestartGameSystem
        add_system Asteroids::ImageRenderSystem
        add_system Asteroids::UIRenderSystem

        setup_background
        setup_player
    end

    private

    def setup_background
        image_c = Asteroids::ImageComponent.new
        image_c.image = game.assets.image('game_bg.png')

        ent = new_entity
        ent.add_component image_c
        ent.add_component Asteroids::TransformComponent.new
    end

    def setup_player
        image_c = Asteroids::ImageComponent.new
        image_c.image = game.assets.image('player.png')

        transform_c = Asteroids::TransformComponent.new
        transform_c.position = Gamey::Vector2.new( game.resolution[:width] / 2, game.resolution[:height] / 2)

        aabb_c = Asteroids::AABBComponent.new
        aabb_c.aabb = Gamey::AABB.new( transform_c.position, image_c.image.size )

        ent = new_entity
        ent.add_component image_c
        ent.add_component transform_c
        ent.add_component aabb_c
        ent.add_component Asteroids::VelocityComponent.new
        ent.add_component Asteroids::PlayerComponent.new
        ent.add_component Asteroids::OnScreenComponent.new
    end
end