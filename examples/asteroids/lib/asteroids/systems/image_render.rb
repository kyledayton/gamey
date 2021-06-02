class Asteroids::ImageRenderSystem < Gamey::RenderSystem
    COMPONENT_MASK = Asteroids::TransformComponent.mask | 
                     Asteroids::ImageComponent.mask

    def render
        entities_with_components(COMPONENT_MASK) do |e|
            image = e.component(Asteroids::ImageComponent).image
            position = e.component(Asteroids::TransformComponent).position
            rotation = e.component(Asteroids::TransformComponent).rotation
            
            image.draw_rot(position.x, position.y, 0, rotation.degrees)
        end
    end
end