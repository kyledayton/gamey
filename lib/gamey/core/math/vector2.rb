class Gamey::Vector2
    attr_accessor :x, :y

    def initialize(x = 0, y = 0)
        @x = x.to_f
        @y = y.to_f
    end

    def length_squared
        x * x + y * y
    end

    def length
        Math.sqrt(length_squared)
    end

    def unit
        len = length
        return Gamey::Vector2.new if len == 0
        
        Gamey::Vector2.new(x / length, y / length)
    end

    def dot(other)
        x * other.x + y * other.y
    end

    def angle_between(other)
        Gamey::Angle.in_radians(Math.atan2(other.y, other.x) - Math.atan2(y, x))
    end

    def rotate(angle)
        Gamey::Vector2.new( x * Math.cos(angle.radians) - y * Math.sin(angle.radians),
                            x * Math.sin(angle.radians) + y * Math.cos(angle.radians))
    end

    def +(other)
        Gamey::Vector2.new(x + other.x, y + other.y)
    end

    def -(other)
        Gamey::Vector2.new(x - other.x, y - other.y)
    end

    def *(scalar)
        Gamey::Vector2.new(x * scalar, y * scalar)
    end

    def /(scalar)
        Gamey::Vector2.new(x / scalar, y / scalar)
    end

    def to_s
        "Gamey::Vector2(#{x},#{y})"
    end
end