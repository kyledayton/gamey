class Asteroids::TransformComponent
    include Gamey::Component

    attr_accessor :position, :rotation

    def initialize
        @position = Gamey::Vector2.new
        @rotation = Gamey::Angle.in_degrees(0)
    end
end