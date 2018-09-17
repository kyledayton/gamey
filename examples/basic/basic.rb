require 'bundler/setup'
require 'gamey'

# Define some components to use in the game
class PositionComponent
    include Gamey::Component

    attr_accessor :position

    def initialize(position = Gamey::Vector2.new)
        @position = position
    end
end

class VelocityComponent
    include Gamey::Component

    attr_accessor :velocity

    def initialize(velocity = Gamey::Vector2.new)
        @velocity = velocity
    end
end

class ImageComponent
    include Gamey::Component

    attr_accessor :image

    def initialize(image = nil)
        @image = image
    end
end

class PlayerComponent # PlayerComponent doesn't hold data, but will be used as a "marker" component.
    include Gamey::Component
end

# Now let's create some systems to add behavior to our game

class PlayerInputSystem < Gamey::System
    COMPONENT_MASK = PlayerComponent.mask | VelocityComponent.mask
    SPEED = 100 # Pixels per second

    def update(dt)
        entities_with_components(COMPONENT_MASK) do |e|
            velocity_c = e.component(VelocityComponent)
            velocity_c.velocity = get_move_direction * SPEED
        end
    end

    private
    
    def get_move_direction
        Gamey::Vector2.new.tap do |move|
            move.y -= 1 if game.input.action(:up).pressed?
            move.y += 1 if game.input.action(:down).pressed?
            move.x -= 1 if game.input.action(:left).pressed?
            move.x += 1 if game.input.action(:right).pressed?
        end
    end 
end

class MovementSystem < Gamey::System
    COMPONENT_MASK = PositionComponent.mask | VelocityComponent.mask

    def update(dt)
        entities_with_components(COMPONENT_MASK) do |e|
            position_c = e.component(PositionComponent)
            velocity_c = e.component(VelocityComponent)

            position_c.position = position_c.position + ( velocity_c.velocity * dt )
        end
    end
end

# Now we will define an ImageRenderSystem for drawing entities with ImageComponents
class ImageRenderSystem < Gamey::RenderSystem
    COMPONENT_MASK = ImageComponent.mask | PositionComponent.mask

    def render
        entities_with_components(COMPONENT_MASK) do |e|
            image = e.component(ImageComponent).image
            position = e.component(PositionComponent).position

            if image
                image.draw_rot(position.x, position.y, 0, 0)
            end
        end
    end
end

# Let's tie all of these systems/components together in our scene
class MainScene < Gamey::Scene
    def setup
        add_system PlayerInputSystem
        add_system MovementSystem
        add_system ImageRenderSystem

        spawn_player
    end

    private

    def spawn_player
        spawn_position = Gamey::Vector2.new( game.resolution[:width]/2, game.resolution[:height]/2 )

        player_entity = new_entity
        player_entity.add_component PlayerComponent.new
        player_entity.add_component PositionComponent.new(spawn_position)
        player_entity.add_component VelocityComponent.new
        player_entity.add_component ImageComponent.new(game.assets.image('ruby.png'))
    end
end

# Finally let's create our game and run it
class MyGame < Gamey::Game
    title 'My Gamey Game'
    resolution width: 800, height: 600

    controls({
        up: [Gosu::KbUp, Gosu::KbW],
        down: [Gosu::KbDown, Gosu::KbS],
        left: [Gosu::KbLeft, Gosu::KbA],
        right: [Gosu::KbRight, Gosu::KbD]
    })

    assets 'assets', { # 'assets' indicates we're using the 'assets' directory relative to this file
        images: 'images' # tell Gamey that images are stored in the 'images' folder inside the 'assets' folder.
    }

    scene MainScene
end

MyGame.new.start