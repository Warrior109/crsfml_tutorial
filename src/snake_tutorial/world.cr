require "./components/snake"

class SnakeTutorial::World
  getter block_size = 16
  @apple_shape = SF::CircleShape.new
  @bounds = { SF::RectangleShape.new, SF::RectangleShape.new, SF::RectangleShape.new, SF::RectangleShape.new }

  def initialize(@window_size : SF::Vector2u)
    max_x = (@window_size.x / @block_size) - 2
    max_y = (@window_size.y / @block_size) - 2
    @item = SF::Vector2i.new(rand(1..max_x), rand(1..max_y))
    respawn_apple
    @apple_shape.fill_color = SF::Color::Red
    @apple_shape.radius = @block_size / 2

    @bounds.each_with_index do |bound, index|
      bound.fill_color = SF::Color.new(150, 0, 0)
      if index.even?
        bound.size = SF.vector2(@window_size.x, @block_size)
      else
        bound.size = SF.vector2(@block_size, @window_size.y)
      end

      if index < 2
        bound.position = SF.vector2(0, 0)
      else
        bound.origin = bound.size
        bound.position = @window_size
      end
    end
  end

  def respawn_apple
    max_x = (@window_size.x / @block_size) - 2
    max_y = (@window_size.y / @block_size) - 2
    @item = SF::Vector2i.new(rand(1..max_x), rand(1..max_y))
    @apple_shape.position = @item * @block_size
  end

  def update(player : SnakeTutorial::Snake)
    if player.position == @item
      player.extend
      player.increase_score
      respawn_apple
    end

    grid_size_x = @window_size.x / @block_size
    grid_size_y = @window_size.y / @block_size

    if player.position.x <= 0 || player.position.y <= 0 ||
        player.position.x >= grid_size_x - 1 || player.position.y >= grid_size_y - 1
      player.lose
    end
  end

  def render(window : SF::RenderWindow)
    @bounds.each { |bound| window.draw(bound) }
    window.draw(@apple_shape)
  end
end
