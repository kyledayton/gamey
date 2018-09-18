require 'set'

class Gamey::Scene
    class Entity
        attr_reader :id, :scene, :components, :mask

        def initialize(id, scene)
            @id = id
            @scene = scene

            @components = Set.new

            @mask = 0
        end

        def add_component(component)
            @components << component
            @mask |= component.mask
        end

        def remove_component(klass)
            if has_components?(klass.mask)
                c = @components.select { |c| c.class == klass }.first
                @components.delete(c)
                @mask ^= klass.mask
            end
        end

        def component(klass)
            @components.select { |c| c.class == klass }.first
        end

        def has_components?(component_mask)
           @mask & component_mask == component_mask
        end

        def destroy
            scene.remove_entity(self)
        end
    end

    attr_reader :entities, :systems, :render_systems

    def initialize(game)
        @game = game
        @entities = Set.new
        @systems = Set.new
        @render_systems = Set.new
        @entities_to_create = Set.new
        @entities_to_remove = Set.new
        @current_id = 0

        setup
    end

    def new_entity
        entity = Entity.new(next_id, self)
        @entities_to_create << entity
        entity
    end

    def remove_entity(e)
        @entities_to_remove << e
        e
    end

    def add_system(klass)
        sys = klass.new
        sys.set_scene(self)
        @systems << sys
        @render_systems << sys if sys.is_a? Gamey::RenderSystem
    end

    def entities_with_components(component_mask)
        @entities.select { |n| n.has_components?(component_mask) }
    end

    def update(dt)
        create_pending_entities
        @systems.each { |s| s.update(dt) }
        remove_pending_entities
    end

    def render
        @render_systems.each { |s| s.render }
    end

    def game
        @game
    end

    def setup
        raise NotImplementedError
    end

    private

    def create_pending_entities
        @entities_to_create.each do |e|
            @entities << e
        end

        @entities_to_create.clear
    end

    def remove_pending_entities
        @entities_to_remove.each do |e|
            @entities.delete(e)
        end

        @entities_to_remove.clear
    end

    def next_id
        id = @current_id
        @current_id += 1
        id
    end
end

class Gamey::DummyScene < Gamey::Scene
    def setup; end
end