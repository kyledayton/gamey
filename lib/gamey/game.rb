class Gamey::Game
    DEFAULT_RESOLUTION = { width: 640, height: 480 }
    DEFAULT_TITLE = 'Gamey'

    def self.resolution(opts = nil)
        unless opts.nil?
            @@resolution = DEFAULT_RESOLUTION.merge(opts)
        end

        return @@resolution
    end

    def resolution=(res)
        self.resolution(res)
    end

    def resolution
        @@resolution
    end

    def self.title(title = nil)
        unless title.nil?
            @@title = title
        end

        return @@title
    end

    def title=(title)
        self.title(title)
    end

    def title
        @@title
    end

    def self.controls(controls = nil)
        unless controls.nil?
            @@controls = controls
        end

        return @@controls
    end

    def controls=(controls)
        self.controls(controls)
    end

    def controls
        @@controls
    end

    def self.scene(scene = nil)
        unless scene.nil?
            @@initial_scene = scene
        end
        return @@initial_scene
    end

    def set_scene(new_scene)
        @@scene = new_scene.new(self)
    end

    def scene=(new_scene)
        @@scene = new_scene.new(self)
    end

    def scene
        @@scene
    end

    def input
        @@input
    end

    def self.assets(asset_path = nil, asset_directores = nil)
        unless asset_path.nil?
            @@assets = Gamey::Assets.new(asset_path, asset_directores)
        end

        return @@assets
    end

    def assets
        @@assets
    end

    def start
        set_defaults

        @@window = Gamey::Window.new(self)
        @@input = Gamey::Input.new(@@window, @@controls)

        @@window.show
    end

    def quit
        @@window.close!
    end

    private

    def set_defaults
        resolution rescue Game.resolution(DEFAULT_RESOLUTION)
        title rescue Game.title(DEFAULT_TITLE)
        controls rescue Game.controls({})
        assets rescue Game.assets('./assets')

        begin
            if @@initial_scene
                set_scene(@@initial_scene)
            end
        rescue
            set_scene(Gamey::DummyScene)
        end
    end
end