require "crsfml"

class SnakeTutorial::Textbox
  @messages = [] of String
  @num_visible = 5
  @backdrop = SF::RectangleShape.new
  @font = SF::Font.from_file("src/fonts/arial.ttf")
  @content = SF::Text.new

  def initialize
    setup(@num_visible, 9, 200, SF::Vector2f.new(0, 0))
  end

  def initialize(@num_visible : Int32, char_size : Int32, width : Int32, screen_pos : SF::Vector2f)
    setup(@num_visible, char_size, width, screen_pos)
  end

  def finalize
    clear
  end

  def setup(@num_visible : Int32, char_size : Int32, width : Int32, screen_pos : SF::Vector2f)
    offset = SF.vector2(2.0, 2.0)
    @content.font = @font
    @content.string = ""
    @content.character_size = char_size
    @content.color = SF::Color::White
    @content.position = screen_pos + offset

    @backdrop.size = SF.vector2(width, @num_visible * char_size * 1.2)
    @backdrop.fill_color = SF::Color.new(90, 90, 90, 90)
    @backdrop.position = screen_pos
  end

  def add(message : String)
    @messages.push(message)
    return if @messages.size < 6
    @messages.shift
  end

  def clear
    @messages.clear
  end

  def render(window : SF::RenderWindow)
    content = ""
    @messages.each do |message|
      content += message
      content += '\n'
    end

    if !content.empty?
      @content.string = content
      window.draw(@backdrop)
      window.draw(@content)
    end
  end
end
