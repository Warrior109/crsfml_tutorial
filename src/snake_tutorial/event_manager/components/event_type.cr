require "crsfml"

class SnakeTutorial::EventManager
  abstract struct EventType
    EVENTS = {
      KeyDown,
      KeyUp,
      MButtonDown,
      MButtonUp,
      MouseWheel,
      WindowResized,
      GainedFocus,
      LostFocus,
      MouseEntered,
      MouseLeft,
      Closed,
      TextEntered,
      Keyboard,
      Mouse,
      Joystick
    }

    @@sf_event_analog = SF::Event

    def self.same_to?(sf_event : SF::Event)
      @@sf_event_analog == sf_event.class
    end

    struct KeyDown < EventType
      @@sf_event_analog = SF::Event::KeyPressed
    end

    struct KeyUp < EventType
      @@sf_event_analog = SF::Event::KeyReleased
    end

    struct MButtonDown < EventType
      @@sf_event_analog = SF::Event::MouseButtonPressed
    end

    struct MButtonUp < EventType
      @@sf_event_analog = SF::Event::MouseButtonReleased
    end

    struct MouseWheel < EventType
      @@sf_event_analog = SF::Event::MouseWheelMoved
    end

    struct WindowResized < EventType
      @@sf_event_analog = SF::Event::Resized
    end

    struct GainedFocus < EventType
      @@sf_event_analog = SF::Event::GainedFocus
    end

    struct LostFocus < EventType
      @@sf_event_analog = SF::Event::LostFocus
    end

    struct MouseEntered < EventType
      @@sf_event_analog = SF::Event::MouseEntered
    end

    struct MouseLeft < EventType
      @@sf_event_analog = SF::Event::MouseLeft
    end

    struct Closed < EventType
      @@sf_event_analog = SF::Event::Closed
    end

    struct TextEntered < EventType
      @@sf_event_analog = SF::Event::TextEntered
    end

    struct Keyboard < EventType
      @@sf_event_analog = SF::Event::KeyEvent
    end

    struct Mouse < EventType
    end

    struct Joystick < EventType
    end
  end
end
