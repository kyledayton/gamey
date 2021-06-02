class Asteroids::BulletComponent
    include Gamey::Component

    attr_accessor :timer

    def initialize
        @timer = Gamey::Timer.new
    end
end