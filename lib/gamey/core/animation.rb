class Gamey::Animation
    attr_reader :frames, :framerate, :timer

    def initialize(frames, frametime = 0.016, loop = true)
        @frames = frames
        @frame_count = @frames.count
        @loop = loop
        @frametime = frametime
        @current_frame_idx = 0
        @timer = Gamey::Timer.new
    end

    def update(dt)
        @timer.update(dt)

        if @timer.elapsed >= @frametime
            @timer.reset
            @current_frame_idx += 1

            if @loop && @current_frame_idx >= @frame_count
                @current_frame_idx = 0
            end
        end
    end

    def current_frame
        @frames[@current_frame_idx]
    end
end