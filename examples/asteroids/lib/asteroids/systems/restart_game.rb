class Asteroids::RestartGameSystem < Gamey::System

    RESTART_DELAY = 3 #seconds

    def update(dt)
        player = entities_with_components(Asteroids::PlayerComponent.mask).first
        player_c = player.component(Asteroids::PlayerComponent)

        if !player_c.alive
            @restart_timer ||= Gamey::Timer.new
            @restart_timer.update(dt)

            if @restart_timer.elapsed >= RESTART_DELAY
                @restart_timer.reset
                game.scene = Asteroids::GameScene
            end
        end
    end
end