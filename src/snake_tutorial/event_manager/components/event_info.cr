class SnakeTutorial::EventManager
  struct EventInfo
    getter code : Int32

    def initialize
      @code = 0
    end

    def initialize(@code : Int32)
    end
  end
end
