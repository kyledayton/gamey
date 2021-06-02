class Asteroids::MovementSystem < Gamey::System
    COMPONENT_MASK = Asteroids::TransformComponent.mask |
                     Asteroids::VelocityComponent.mask

    def update(dt)
        entities_with_components(COMPONENT_MASK) do |e|
            transform_c = e.component(Asteroids::TransformComponent)
            pos = transform_c.position
            rot = transform_c.rotation
            vel = e.component(Asteroids::VelocityComponent).linear_velocity
            ang_vel = e.component(Asteroids::VelocityComponent).angular_velocity
            
            transform_c.position = pos + (vel * dt)
            transform_c.rotation = rot + Gamey::Angle.in_degrees(ang_vel * dt)
        end
    end
end