class Asteroids::Game < Gamey::Game
    title 'Asteroids'
    resolution width: 800, height: 600

    controls({
        forward: [Gosu::KbUp, Gosu::KbW],
        left: [Gosu::KbLeft, Gosu::KbA],
        right: [Gosu::KbRight, Gosu::KbD],
        start_game: [Gosu::KbSpace],
        shoot: [Gosu::KbSpace]
    })

    assets 'assets', {
        images: 'images',
        fonts: 'fonts',
        sounds: 'sounds'
    }

    scene Asteroids::GameScene
end