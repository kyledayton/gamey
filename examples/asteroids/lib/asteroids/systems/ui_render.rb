class Asteroids::UIRenderSystem < Gamey::RenderSystem
    def render
        @font ||= game.assets.font('score.ttf', 18)

        player = entities_with_components(Asteroids::PlayerComponent.mask).first

        if player
            player_c = player.component(Asteroids::PlayerComponent)
            score = player_c.score.to_s

            @font.draw(score, game.resolution[:width] - (16 * score.length), 16, 0)
        end
    end
end