class Gamey::Ray
    attr_accessor :origin, :direction, :inverse_direction

    def initialize(origin = Gamey::Vector2.new, direction = Gamey::Angle.in_degrees(0))
        @origin = origin
        @direction = direction.to_vector2
        @inverse_direction = Gamey::Vector2.new(1.0 / @direction.x, 1.0 / @direction.y)
    end
end

class Gamey::RaycastResult
    attr_accessor :position, :normal
end


