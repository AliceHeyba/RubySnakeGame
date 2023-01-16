require "ruby2d"

set background: "navy"
#fps cap is how quickly the frame reloads. ie. in def move we want the first position of the snake to be deleted when the new position is created (to create a movement: one position gone & one position added). if we dont set fps cap to 1 then this happens so quickly that our entire snake body/all positions get deleted and we don't see anything on the screen. if it s fps cap: 1 1 position/body piece disappears (....) per second and we can follow it on our screen.
# fps = frames per second. initially set up with 60 frames / sec - below with 10 frame / sec
set fps_cap: 10

#window width is 640 by default --> grid size 20 x 32 times
# window height is 480 --> grid size 20 x24
GRID_SIZE = 20
#make the snake reappear on the frame when it goes beyond what we see
# our window is 32 grids wide and 24 grids high
GRID_WIDTH = Window.width / GRID_SIZE
GRID_HEIGHT = Window.height / GRID_SIZE

# position first number in position array is first number x axis (horizontal), 2nd number y axis (vertical)

class Snake
  #in order for the key down event to be registered in direction we need to have a attr writer to update it
  attr_writer :direction

  # if @growing = true then it would grow each time the frame is loaded (10 times per second for example)
 def initialize
  @positions = [[2, 0], [2, 1], [2, 2], [2, 3]]
  @direction = "down"
  @growing = false
 end

 # draw is a square for each position (body of snake). each square is size of grid
 # .each: we create a square * GRID_SIZE is used to locate the square on y and x axis. size: GRID determines the size of each position/body part
 # the -1 on y position is used to have a 1px line between each piece of the body (on y axis)
 # Q what is the difference between x: position[0] * grid size and size: Grid_size?
  def draw
    @positions.each do |position|
      Square.new(x: position[0] * GRID_SIZE, y: position[1] * GRID_SIZE, size: GRID_SIZE - 1 , color: "white")
    end
  end

  def grow
    @growing = true
  end

  # only remove the last element of the snake if we are not growing
  def move
    if !@growing
      @positions.shift
    end

    @positions.push(next_position)
    @growing = false
  end

  #for they key down event if statement  - if direction (current and new_direction (new)
  def snake_can_change_direction_to?(new_direction)
    case @direction
      when "up" then new_direction != "down"
      when "down" then new_direction != "up"
      when "left" then new_direction != "right"
      when "right" then new_direction != "left"
    end
  end

#x and y are needed for our snake_hit_ball method
  def x
    head[0]
  end

  def y
    head[1]
  end

  def next_position
    case @direction
      when "down"
        #.shift removes the first element of an array, so from def initialize the [2, 0]. we want to remove that position and add a new positon at the other end of the snake to make it appear as if it s moving. adding new element to array.
        # new coords method was added later. remember: % (=modulo operator) gives remaining after its been divided. so 33 % 31 = 1. meaning that the x axis 33 --> 1 (note: 24 % 32  is 24. 24 divided by 32 is 0 with a remainder of 24)
        new_coords(head[0], head[1] + 1)
      when "up"
        new_coords(head[0], head[1] - 1)
      when "left"
        new_coords(head[0] - 1, head[1])
      when "right"
        new_coords(head[0] + 1, head[1])
    end
  end

  def hit_itself?
    @positions.uniq.length != @positions.length
  end

  private




  # for when we want to call the head of the snake
  def head
    @positions.last
  end

  def new_coords(x,y)
    [x % GRID_WIDTH, y % GRID_HEIGHT]
  end
end




class Game
  def initialize
    @score = 0
    @ball_x = rand(GRID_WIDTH)
    @ball_y = rand(GRID_HEIGHT)
    @finished = false
  end

  # note we dont need to create the class for square nor for text - these are inbuilt
  def draw
    unless finished?
      Square.new(x: @ball_x * GRID_SIZE, y: @ball_y * GRID_SIZE, size: GRID_SIZE, color: "orange")
    end
    Text.new(text_message, color: "green", x: 10, y: 10, size: 30)
  end

  def snake_hit_ball?(x, y)
    @ball_x == x && @ball_y == y
  end

  def record_hit
    @score += 1
    @ball_x = rand(GRID_WIDTH)
    @ball_y = rand(GRID_HEIGHT)
  end

  def finish
    @finished = true
  end

  def finished?
    @finished
  end

  private
  def text_message
    if finished?
      "Game Over. Press '1' to restart"
    else
      "Level: #{@score}"
    end
  end
end

snake = Snake.new
game = Game.new
# each frame (= each second due to fps_cap 1) is an update, so this happens every second: clear, move, draw...)
update do
  # clear each time screen is refreshed/new frame, else we draw our snake on top of the existing snake
  clear
  unless game.finished?
    snake.move
  end
  snake.draw
  game.draw

  if game.snake_hit_ball?(snake.x, snake.y)
    game.record_hit
    snake.grow
  end

  if snake.hit_itself?
    game.finish
  end
end

on :key_down do |event|
  if ["up", "down", "left", "right"].include?(event.key)
    if snake.snake_can_change_direction_to?(event.key)
      snake.direction = event.key
    end
  end

  if event.key == "1" && game.finished?
    snake = Snake.new
    game = Game.new
  end
end

show
