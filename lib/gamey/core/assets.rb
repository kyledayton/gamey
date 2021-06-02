class Gamey::Assets
    def initialize(base_path, asset_directories = {})
        @base_path = base_path
        @asset_directories = asset_directories
        @cache = {}
    end

    def image(path)
        load_from_cache(path) { Gosu::Image.new(full_path_to_asset(:images, path)) }
    end

    def sound(path)
        load_from_cache(path) { Gosu::Sample.new(full_path_to_asset(:sounds, path)) }
    end

    def song(path)
        load_from_cache(path) { Gosu::Song.new(full_path_to_asset(:music, path)) }
    end

    def font(path, height = 12)
        load_from_cache("#{path}/#{height}") { Gosu::Font.new(height, name: full_path_to_asset(:fonts, path)) }
    end

    private

    def load_from_cache(path, &block)
        if existing = @cache[path]
            return existing
        end

        asset = block.call

        @cache[path] = asset
        return asset
    end

    def full_path_to_asset(type, path)
        if asset_dir = @asset_directories[type]
            File.expand_path(File.join(@base_path, asset_dir, path))
        else
            File.expand_path(File.join(@base_path, path))
        end
    end
end