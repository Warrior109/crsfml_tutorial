require "crsfml"

class SnakeTutorial::EventManager
  class EventDetails
    property name
    property size
    property text_entered : UInt32
    property mouse
    property mouse_wheel_delta
    property key_code

    def initialize(@name : String)
      @size = SF::Vector2(UInt32).new(0, 0)
      @text_entered = 0
      @mouse = SF::Vector2i.new(0, 0)
      @mouse_wheel_delta = 0
      @key_code = -1
    end

    def clear
      @size = SF::Vector2(UInt32).new(0, 0)
      @text_entered = 0
      @mouse = SF.vector2(0, 0)
      @mouse_wheel_delta = 0
      @key_code = -1
    end
  end
end
