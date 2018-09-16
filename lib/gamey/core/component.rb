module Gamey::Component
    @@next_mask = 0

    def self.included(base)
        base.class_eval """
            def self.mask
                1 << #{@@next_mask}
            end

            def mask
                1 << #{@@next_mask}
            end
        """

        @@next_mask += 1
    end

    def mask
        raise NotImplementedError
    end

    def self.mask
        raise NotImplementedError
    end
end