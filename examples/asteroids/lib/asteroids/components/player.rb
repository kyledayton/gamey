class Asteroids::PlayerComponent
    include Gamey::Component

    attr_accessor :score, :alive, :did_shoot, :shot_timer, :thrust_sound

    def initialize
        @score = 0
        @alive = true
        @did_shoot = false
        @shot_timer = Gamey::Timer.new
    end
end