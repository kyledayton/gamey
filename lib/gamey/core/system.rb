class Gamey::System
    def initialize
        @scene = nil
    end

    def set_scene(scene)
        @scene = scene
    end

    def entities_with_components(component_mask)
        entities = @scene.entities_with_components(component_mask)
        count = entities.size
        entities.each { |e| yield e, count } if block_given?

        return entities
    end

    def update(dt)
    end

    def game
        @scene.game
    end
    
    def scene
        @scene
    end
end

class Gamey::RenderSystem < Gamey::System
    def render
    end
end