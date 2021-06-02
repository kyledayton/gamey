class Gamey::Timer
    attr_reader :elapsed

    def initialize
        @elapsed = 0.0
    end

    def update(dt)
        @elapsed += dt
    end

    def reset
        @elapsed = 0.0
    end
end