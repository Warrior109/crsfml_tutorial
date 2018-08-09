class SnakeTutorial::Snake
  class Segment
    property position : SF::Vector2i

    def initialize(x : Int32, y : Int32)
      @position = SF.vector2(x, y)
    end
  end
end
