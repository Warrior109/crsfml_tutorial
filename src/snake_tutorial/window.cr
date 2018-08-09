class SnakeTutorial::Window
  getter size = SF.vector2(640, 480)
  getter window = SF::RenderWindow.new
  @title = "Window"

  def initialize
    setup(@title, @size)
  end

  def initialize(title : String, size : SF::Vector2u)
    setup(title, size)
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
      if event.is_a? SF::Event::Closed
        @isDone = true
      elsif event.is_a? SF::Event::KeyPressed && SF::Keyboard.key_pressed?(SF::Keyboard::F5)
        toggle_fullscreen
      end
    end
  end

  def done?
    @isDone
  end

  def fullscreen?
    @isFullscreen
  end

  def toggle_fullscreen
    @isFullscreen = !@isFullscreen
    destroy
    create
  end

  def draw(drawable : SF::Drawable)
    @window.draw(drawable)
  end

  private def setup(@title : String, @size : SF::Vector2u)
    @isFullscreen = false
    @isDone = false
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
