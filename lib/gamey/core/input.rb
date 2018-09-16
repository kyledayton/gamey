class Gamey::Input
    class Action
        attr_reader :name

        def initialize(name)
            @name = name
            @state = false
            @last_state = false
        end

        def pressed?
            @state
        end

        def released?
            !@state
        end

        def just_pressed?
            @state && !@last_state
        end

        def just_released?
            !@state && @last_state
        end

        def update(new_state)
            @last_state = @state
            @state = new_state
        end
    end

    def initialize(window, bindings)
        @window = window
        @actions = {}
        @bindings = bindings
        @bindings.keys.each do |action|
            @actions[action] = Action.new(action)
        end
    end

    def update
        @actions.each do |name, action|
            keys = @bindings[name]
            state = keys.any? { |k| @window.button_down?(k) }
            action.update(state)
        end
    end

    def action(name)
        @actions[name]
    end

    def release_all
        @actions.each { |a| a.update(false) }
    end
end
