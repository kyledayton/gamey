class Asteroids::OffScreenSystem < Gamey::System
    COMPONENT_MASK = Asteroids::TransformComponent.mask |
                     Asteroids::OnScreenComponent.mask

    MARGIN = 32

    def update(dt)
        width = game.resolution[:width]
        height = game.resolution[:height]

        entities_with_components(COMPONENT_MASK) do |e|
            transform = e.component(Asteroids::TransformComponent)

            if transform.position.y < -MARGIN
                transform.position.y = -transform.position.y + height
            elsif transform.position.y > height + MARGIN
                transform.position.y = transform.position.y - height - (MARGIN * 2)
            end

            if transform.position.x < -MARGIN
                transform.position.x = -transform.position.x + width
            elsif transform.position.x > width + MARGIN
                transform.position.x = transform.position.x - width - (MARGIN * 2)
            end
        end
    end
end