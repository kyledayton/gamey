class Gamey::AABB
    attr_accessor :center, :size, :extents

    def initialize(center, size)
        @center = center
        @size = size
        @extents = @size / 2
    end

    def center=(new_center)
        @center = new_center
    end

    def min
        Gamey::Vector2.new(center.x - extents.x, center.y - extents.y)
    end

    def max
        Gamey::Vector2.new(center.x + extents.x, center.y + extents.y)
    end

    def minkowski(other)
        combined_size = size + other.size
        Gamey::AABB.new( (min - other.max) + (combined_size / 2), combined_size)
    end

    def intersects?(other)
        self.minkowski(other).contains?(Gamey::Vector2.new)
    end

    def contains?(vector2)
        vector2.x >= min.x && vector2.y >= min.y && vector2.x <= max.x && vector2.y <= max.y
    end

    def min_displacement_to_bounds
        to_pos = Gamey::Vector2.new
        dist = (to_pos.x - min.x).abs
        bounds_point = Gamey::Vector2.new(min.x, to_pos.y)

        if (max.x - to_pos.x).abs < dist
            dist = (max.x - to_pos.x).abs
            bounds_point = Gamey::Vector2.new(max.x, to_pos.y)
        end

        if (max.y - to_pos.y).abs < dist
            dist = (max.y - to_pos.y).abs
            bounds_point = Gamey::Vector2.new(to_pos.x, max.y);
        end

        if (min.y - to_pos.y).abs < dist
            dist = (min.y - to_pos.y).abs
            bounds_point = Gamey::Vector2.new(to_pos.x, min.y)
        end

        bounds_point
    end

    def ray_intersect(ray)
        bmin = min
        bmax = max

        tx1 = (bmin.x - ray.origin.x) * r.inverse_direction.x
        tx2 = (bmax.x - ray.origin.x) * r.inverse_direction.x

        tmin = [tx1, tx2].min
        tmax = [tx1, tx2].max

        ty1 = (bmin.y - r.origin.y) * r.inverse_direction.y
        ty2 = (bmax.y - r.origin.y) * r.inverse_direction.y

        tmin = [tmin, [ty1, ty2].min].max
        tmax = [tmax, [ty1, ty2].max].min

        result = nil

        if tmax > 0.0 && tmax >= tmin
            result = Gamey::RaycastResult.new

            if tmin < 0.0
                result.position = ray.origin + (ray.direction * tmax)
            else
                result.position = ray.origin + (ray.direction * tmin)
            end

            if (result.position.x - bmin.x).abs <= Float::EPSILON
                result.normal = Gamey::Vector2.new(-1, 0)
            elsif (result.position.x - bmax.x).abs <= Float::EPSILION
                result.normal = Gamey::Vector2.new(1, 0)
            elsif (result.position.y - bmin.y).abs <= Float::EPSILION
                result.normal = Gamey::Vector2.new(0, -1)
            else
                result.normal = Gamey::Vector2.new(0, 1)
            end
        end

        return result
    end
end
