# Gamey

Gamey is a game framework for Ruby, based on [gosu](https://github.com/gosu/gosu). Gamey provides ECS (Entity-Component-System) architecture for implementing your game in an organized manner.

## Installation

Gamey depends on gosu, so ensure gosu's dependencies are installed before using Gamey. For more information about gosu's dependencies, check out the [gosu wiki](https://github.com/gosu/gosu/wiki).

Add this line to your application's Gemfile:

```ruby
gem 'gamey'
```

And then execute:

    $ bundle

Or install it yourself as:

    $ gem install gamey

## Usage

### Game
The core of a Gamey application is the `Game`.

```ruby
class MyGame < Gamey::Game
    title 'My Gamey Game'
    resolution width: 800, height: 600

    controls({
        left: [Gosu::KbA, Gosu::KbLeft],
        right: [Gosu::KbD, Gosu::KbRight],
        jump: [Gosu::KbSpace]
    })

    assets 'data', {
        images: 'textures',
        sounds: 'sfx'
    }

    scene MainScene
end

MyGame.new.start
```

In the above example, we create a subclass of `Gamey::Game`, and configure the window, controls, assets, as well as specify the default `Scene`.

### Scene
Scenes hold your game's entities and systems. You may have different scenes in your game (such as Menu, Game, Game Over, etc..). Gamey expects a `setup` method to be defined in your scene.

```ruby
class MainScene < Gamey::Scene
    def setup
        add_system PlayerInputSystem
        add_system MovementSystem
        add_system ImageRenderSystem

        spawn_player
    end

    private

    def spawn_player
        spawn_position = Gamey::Vector2.new( game.resolution[:width]/2, game.resolution[:height]/2)

        position_c = PositionComponent.new(spawn_position)
        velocity_c = VelocityComponent.new
        player_c = PlayerComponent.new
        image_c = ImageComponent.new
        image_c.image = game.assets.image('player.png')

        player = new_entity
        player.add_component position_c
        player.add_component velocity_c
        player.add_component player_c
        player.add_component image_c
    end
end
```

In the above example, we define a `MainScene`, attach a few systems to the scene, and create a player entity that has a handful of components.

### Components
Components hold data related to your entities, and are processed by systems to provide behavior to your entities.

```ruby
class PositionComponent
    include Gamey::Component

    attr_accessor :position

    def initialize(position = Gamey::Vector2.new )
        @position = position
    end
end
```

### Systems
Systems are where your game's logic is implemented. Systems are run in the order they are attached to the scene, and are called once per frame.

```ruby
class PlayerInputSystem < Gamey::System
    COMPONENT_MASK = PlayerComponent.mask | VelocityComponent.mask
    MOVE_SPEED = 100 # pixels per second

    def update(dt)
        entities_with_components(COMPONENT_MASK) do |e|
            velocity_c = e.component(VelocityComponent)
            move = Gamey::Vector2.new

            move.x -= 1 if game.input.action(:left).pressed?
            move.x += 1 if game.input.action(:right).pressed?

            velocity_c.velocity = move * MOVE_SPEED
        end
    end
end

class MovementSystem < Gamey::System
    COMPONENT_MASK = PositionComponent.mask | VelocityComponent.mask

    def update(dt)
        entities_with_components(COMPONENT_MASK) do |e|
            position_c = e.component(PositionComponent)
            velocity_c = e.component(VelocityComponent)

            position_c.position = position_c.position + (velocity_c.velocity * dt)
        end
    end
end
```

In the above example we define 2 different systems. `PlayerInputSystem` retrieves all entities in the scene with BOTH a `PlayerComponent` and `VelocityComponent`, and then checks the game's input manager to determine how to set the player's velocity.

The `MovementSystem` takes all entities in the scene with `PositionComponent` and `VelocityComponent`, and updates the position from the entities velocity in a frame-rate-independent manner.


#### Render Systems
Gamey also supports `RenderSystem`s, which are tied into the render pipeline. The primary difference between `System` and `RenderSystem` is that `System` expects an `update` method, while `RenderSystem` expects a `render` method.

```ruby
class ImageRenderSystem < Gamey::RenderSystem
    COMPONENT_MASK = ImageComponent.mask | PositionComponent.mask

    def render
        entities_with_components(COMPONENT_MASK) do |e|
            image = e.component(ImageComponent).image
            position = e.component(PositionComponent).position

            image.draw(position.x, position.y, 0)
        end
    end
end
```

In the above example, we define an `ImageRenderSystem`, which takes all entities with both `ImageComponent` and `PositionComponent`, and draws the image to the screen at the entities position.

## Contributing

Bug reports and pull requests are welcome on GitHub at https://github.com/kyledayton/gamey.

## License

The gem is available as open source under the terms of the [MIT License](https://opensource.org/licenses/MIT).
