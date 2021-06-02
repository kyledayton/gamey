class Asteroids::AABBComponent
    include Gamey::Component

    attr_accessor :aabb

    def initialize
        @aabb = Gamey::AABB.new( Gamey::Vector2.new, Gamey::Vector2.new )
    end
end