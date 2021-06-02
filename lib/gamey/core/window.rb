class Gamey::Window < Gosu::Window

    def initialize(game)
        @game = game

        super(@game.resolution[:width], @game.resolution[:height])
        self.caption = @game.title || 'Gamey'

        @last_time = 0
    end

    def update
        current = Gosu::milliseconds
        dt = (current - @last_time) * 0.001
        @last_time = current

        @game.input.update
        @game.scene.update(dt)
    end

    def draw
        @game.scene.render
    end
end
