class Asteroids::AABBUpdateSystem < Gamey::System
    COMPONENT_MASK = Asteroids::TransformComponent.mask |
                     Asteroids::AABBComponent.mask

    def update(dt)
        entities_with_components(COMPONENT_MASK) do |e|
            transform = e.component(Asteroids::TransformComponent)
            aabb_c = e.component(Asteroids::AABBComponent)

            aabb_c.aabb.center = transform.position
        end
    end
end