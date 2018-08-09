require "./components/segment"
require "./enums/*"

class SnakeTutorial::Snake
  property direction = Direction::None
  getter speed = 15
  getter lives = 3
  getter score = 0

  @snake_body = [] of Segment
  @size : Int32
  @body_rect = SF::RectangleShape.new

  def initialize(@size : Int32)
    @body_rect.size = SF.vector2(@size - 1, @size - 1)
    reset
  end

  def position
    @snake_body.empty? ? SF.vector2(1, 1) : @snake_body.first.position
  end

  def increase_score
    @score += 10
  end

  def lost?
    @lost
  end

  def lose
    @lost = true
  end

  def toggle_lost
    @lost = !@lost
  end

  def physical_direction : Direction
    return Direction::None if @snake_body.size <= 1

    head = @snake_body.first
    neck = @snake_body[1]

    if head.position.x == neck.position.x
      head.position.y > neck.position.y ? Direction::Down : Direction::Up
    elsif head.position.y == neck.position.y
      head.position.x > neck.position.x ? Direction::Right : Direction::Left
    else
      Direction::None
    end
  end

  def extend
    return if @snake_body.empty?

    tail_head = @snake_body.last

    if @snake_body.size > 1
      tail_bone = @snake_body[-2]
      if tail_head.position.x == tail_bone.position.x
        if tail_head.position.y > tail_bone.position.y
          @snake_body.push(Segment.new(tail_head.position.x, tail_head.position.y + 1))
        else
          @snake_body.push(Segment.new(tail_head.position.x, tail_head.position.y - 1))
        end
      elsif tail_head.position.y == tail_bone.position.y
        if tail_head.position.x > tail_bone.position.x
          @snake_body.push(Segment.new(tail_head.position.x + 1, tail_head.position.y))
        else
          @snake_body.push(Segment.new(tail_head.position.x - 1, tail_head.position.y))
        end
      end
    else
      case @direction
      when .up?
        @snake_body.push(Segment.new(tail_head.position.x, tail_head.position.y + 1))
      when .down?
        @snake_body.push(Segment.new(tail_head.position.x, tail_head.position.y - 1))
      when .left?
        @snake_body.push(Segment.new(tail_head.position.x + 1, tail_head.position.y))
      when .right?
        @snake_body.push(Segment.new(tail_head.position.x - 1, tail_head.position.y))
      end
    end
  end

  def reset
    @snake_body = [Segment.new(5, 5), Segment.new(5, 6), Segment.new(5, 7)]
    @direction = Direction::None
    @speed = 15
    @lives = 3
    @score = 0
    @lost = false
  end

  def move
    i = @snake_body.size - 1
    while i > 0
      @snake_body[i].position = @snake_body[i - 1].position
      i -= 1
    end
    head = @snake_body.first
    case @direction
    when .left?
      head.position = SF.vector2(head.position.x - 1, head.position.y)
    when .right?
      head.position = SF.vector2(head.position.x + 1, head.position.y)
    when .up?
      head.position = SF.vector2(head.position.x, head.position.y - 1)
    when .down?
      head.position = SF.vector2(head.position.x, head.position.y + 1)
    end
  end

  def tick
    return if @snake_body.empty? || @direction.none?
    move
    check_collision
  end

  def cut(segments_count : Int32)
    @snake_body.pop(segments_count)
    @lives -= 1
    return lose if @lives.zero?
  end

  def render(window : SF::RenderWindow)
    return if @snake_body.empty?

    head = @snake_body.first
    @body_rect.fill_color = SF::Color::Yellow
    @body_rect.position = head.position * @size
    window.draw(@body_rect)

    @body_rect.fill_color = SF::Color::Green
    @snake_body.each(start: 1, count: @snake_body.size - 1) do |segment|
      @body_rect.position = segment.position * @size
      window.draw(@body_rect)
    end
  end

  def check_collision
    return if @snake_body.size < 5
    head = @snake_body.first
    @snake_body[1..-1].each_with_index do |segment, index|
      if segment.position == head.position
        segments_count = @snake_body.size - index
        cut(segments_count)
        break
      end
    end
  end
end
