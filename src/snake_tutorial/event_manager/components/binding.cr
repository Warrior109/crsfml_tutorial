require "./event_details.cr"
require "./event_info.cr"
require "./event_type.cr"

class SnakeTutorial::EventManager
  class Binding
    getter name : String
    getter events = {} of EventType.class => EventInfo
    getter details : EventDetails
    property c : Int32

    def initialize(@name : String)
      @details = EventDetails.new(@name)
      @c = 0
    end

    def bind_event(type : EventType.class, info = EventInfo.new)
      @events[type] = info
    end
  end
end
