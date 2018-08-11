require "crsfml"
require "./event_manager"

class SnakeTutorial::Window
  getter size = SF.vector2(640, 480)
  getter window = SF::RenderWindow.new
  getter event_manager = SnakeTutorial::EventManager.new
  @isFocused = true
  @title = "Window"

  def initialize
    setup(@title, @size)
  end

  def initialize(title : String, size : SF::Vector2u)
    setup(title, size)
  end

  def focused?
    @isFocused
  end

  def finalize
    destroy
  end

  def begin_draw
    @window.clear(SF::Color::Black)
  end

  def end_draw
    @window.display
  end

  def update
    while event = @window.poll_event
      if event.is_a? SF::Event::LostFocus
        @isFocused = false
        @event_manager.focus = false
      elsif event.is_a? SF::Event::GainedFocus
        @isFocused = true
        @event_manager.focus = true
      end
      @event_manager.handle_event(event)
    end
    @event_manager.update
  end

  def done?
    @isDone
  end

  def fullscreen?
    @isFullscreen
  end

  def toggle_fullscreen(details : EventManager::EventDetails)
    @isFullscreen = !@isFullscreen
    destroy
    create
  end

  def close(details = nil)
    @isDone = true
  end

  def draw(drawable : SF::Drawable)
    @window.draw(drawable)
  end

  private def setup(@title : String, @size : SF::Vector2u)
    @isFocused = true
    @isFullscreen = false
    @isDone = false
    @event_manager.add_callback("fullscreen_toggle", ->toggle_fullscreen(EventManager::EventDetails))
    @event_manager.add_callback("window_close", ->close(EventManager::EventDetails))
    create
  end

  private def create
    style = @isFullscreen ? SF::Style::Fullscreen : SF::Style::Default
    @window.create(SF::VideoMode.new(@size.x, @size.y), @title, style)
    @window.framerate_limit = 60
  end

  private def destroy
    @window.close
  end
end
