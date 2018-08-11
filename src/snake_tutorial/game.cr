require "crsfml"
require "./components/snake"
require "./components/textbox"
require "./window.cr"

class SnakeTutorial::Game
  getter window = SnakeTutorial::Window.new("Snake", SF.vector2(800, 600))
  getter elapsed = SF::Time.new
  @increment : SF::Vector2u
  @clock = SF::Clock.new

  def initialize
    @increment = SF.vector2(400, 400)
    @world = SnakeTutorial::World.new(SF.vector2(800, 600))
    @snake = SnakeTutorial::Snake.new(@world.block_size)
    @textbox = SnakeTutorial::Textbox.new
    @textbox.add("Seeded random number generator with: lalka")
  end

  def handle_input
    if SF::Keyboard.key_pressed?(SF::Keyboard::Up) && !@snake.physical_direction.down?
      @snake.direction = SnakeTutorial::Snake::Direction::Up
    elsif SF::Keyboard.key_pressed?(SF::Keyboard::Down) && !@snake.physical_direction.up?
      @snake.direction = SnakeTutorial::Snake::Direction::Down
    elsif SF::Keyboard.key_pressed?(SF::Keyboard::Left) && !@snake.physical_direction.right?
      @snake.direction = SnakeTutorial::Snake::Direction::Left
    elsif SF::Keyboard.key_pressed?(SF::Keyboard::Right) && !@snake.physical_direction.left?
      @snake.direction = SnakeTutorial::Snake::Direction::Right
    end
  end

  def update
    @window.update

    timestep = 1.0 / @snake.speed.to_f

    if @elapsed.as_seconds >= timestep
      @snake.tick
      @world.update(@snake)
      @elapsed -= SF.seconds(timestep)
      @snake.reset if @snake.lost?
    end
  end

  def render
    @window.begin_draw
    @world.render(@window.window)
    @snake.render(@window.window)
    @textbox.render(@window.window)
    @window.end_draw
  end

  def restart_clock
    @elapsed += @clock.restart
  end
end
