class Gamey::Angle < Numeric
    attr_accessor :radians, :degrees
    
    TAU = Math::PI * 2.0

    DEG2RAD = TAU / 360.0
    RAD2DEG = 360.0 / TAU

    def initialize(radians)
        @radians = radians
        @degrees = radians * RAD2DEG
    end

    def self.in_radians(radians)
        new(radians)
    end

    def self.in_degrees(degrees)
        new(degrees * DEG2RAD)
    end

    def to_vector2
        Gamey::Vector2.new(-Math.sin(radians), Math.cos(radians))
    end

    def +(other)
        Gamey::Angle.new( @radians + other.radians )
    end

    def -(other)
        Gamey::Angle.new( @radians - other.radians )
    end

    def *(scalar)
        Gamey::Angle.new( @radians * scalar )
    end

    def /(scalar)
        Gamey::Angle.new( @radians / scalar )
    end

    def to_s
        "Gamey::Angle(#{degrees}d, #{radians}r)"
    end
end