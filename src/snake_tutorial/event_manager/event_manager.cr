require "./components/*"
require "yaml"

module SnakeTutorial
  class EventManager
    alias Callbacks = Hash(String, Proc(EventDetails, Nil))
    alias Bindings = Hash(String, Binding)

    property focus = true
    @callbacks = Callbacks.new
    @bindings = Bindings.new

    def initialize
      load_bindings
    end

    def add_binding(binding : Binding)
      return false if @bindings[binding.name]

      @bindings[binding.name] = binding
    end

    def remove_binding(name : String)
      @bindings.delete(name)
    end

    def add_callback(name : String, callback : Proc)
      return false if @bindings[name]

      @callbacks[name] = callback
    end

    def remove_callback(name : String)
      @callbacks.delete(name)
    end

    def handle_event(event_attr : SF::Event)
      @bindings.each do |binding_name, binding|
        binding.events.each do |event_type, event|
          next if !event_type.same_to?(event_attr)

          if event_attr.is_a?(SF::Event::KeyPressed | SF::Event::KeyReleased)
            if event.code == event_attr.code
              binding.details.key_code = event.code if binding.details.key_code != -1
              binding.c += 1
              break
            end
          elsif event_attr.is_a?(SF::Event::MouseButtonPressed | SF::Event::MouseButtonReleased)
            if event.code == event_attr.button
              binding.details.mouse.x = event_attr.x
              binding.details.mouse.y = event_attr.y
              binding.details.key_code = event.code if binding.details.key_code != -1
              binding.c += 1
            end
          else
            if event_attr.is_a?(SF::Event::MouseWheelMoved)
              binding.details.mouse_wheel_delta = event_attr.delta
            elsif event_attr.is_a?(SF::Event::Resized)
              binding.details.size = SF.vector2(event_attr.width, event_attr.height)
            elsif event_attr.is_a?(SF::Event::TextEntered)
              binding.details.text_entered = event_attr.unicode
            end
            binding.c += 1
          end
        end
      end
    end

    def update
      return unless @focus

      @bindings.each do |binding_name, binding|
        binding.events.each do |event_type, event|
          case event_type
          when EventType::Keyboard
            if SF::Keyboard.key_pressed?(SF::Keyboard::Key.new(event.code))
              binding.details.key_code = event.code if binding.details.key_code != -1
              binding.c += 1
            end
            break
          when EventType::Mouse
            if SF::Mouse.button_pressed?(SF::Mouse::Button.new(event.code))
              binding.details.key_code = event.code if binding.details.key_code != -1
              binding.c += 1
            end
            break
          when EventType::Joystick
            break
          end
        end
        if binding.events.size  == binding.c
          callback = @callbacks[binding.name]
          callback.call(binding.details) if callback
        end
        binding.c == 0
        binding.details.clear
      end
    end

    def mouse_pos(window : SF::RenderWindow = nil)
      return window ? SF::Mouse.position(window) : SF::Mouse.position
    end

    private def load_bindings
      delimiter = ":"
      config = YAML.parse(File.read("src/data/events.yml")).as_h
      config.each do |callback_name, keys|
        binding = Binding.new(callback_name.to_s)
        keys.as_a.each do |key|
          event_code, sf_event_code = key.to_s.split(delimiter)
          type = EventType::EVENTS[event_code.to_i]
          event_info = EventInfo.new(sf_event_code.to_i)
          binding.bind_event(type, event_info)
        end
      end
    end
  end
end

