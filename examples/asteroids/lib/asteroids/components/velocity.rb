class Asteroids::VelocityComponent
    include Gamey::Component

    attr_accessor :linear_velocity, :angular_velocity

    def initialize
        @linear_velocity = Gamey::Vector2.new
        @angular_velocity = 0
    end
end