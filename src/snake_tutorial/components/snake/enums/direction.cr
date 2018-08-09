class SnakeTutorial::Snake
  enum Direction
    None
    Up
    Down
    Left
    Right

    def none?
      self == Direction::None
    end

    def up?
      self == Direction::Up
    end

    def down?
      self == Direction::Down
    end

    def left?
      self == Direction::Left
    end

    def right?
      self == Direction::Right
    end
  end
end
