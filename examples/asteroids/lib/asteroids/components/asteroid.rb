class Asteroids::AsteroidComponent
    include Gamey::Component

    attr_accessor :small

    def initialize
        @small = false
    end
end