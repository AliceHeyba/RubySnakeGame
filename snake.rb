require "ruby2d"

set background: "navy"
#fps cap is how quickly the frame reloads. ie. in def move we want the first position of the snake to be deleted when the new position is created (to create a movement: one position gone & one position added). if we dont set fps cap to 1 then this happens so quickly that our entire snake body/all positions get deleted and we don't see anything on the screen. if it s fps cap: 1 1 position/body piece disappears (....) per second and we can follow it on our screen.
# fps = frames per second. initially set up with 60 frames / sec - below with 10 frame / sec
set fps_cap: 10

#window width is 640 by default --> grid size 20 x 32 times
# window height is 480
GRID_SIZE = 20

# position first number in position array is first number x axis (horizontal), 2nd number y axis (vertical)

class Snake
  #in order for the key down event to be registered in direction we need to have a attr writer to update it
  attr_writer :direction

 def initialize
  @positions = [[2, 0], [2, 1], [2, 2], [2, 3]]
  @direction = "down"
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

  #
  def move
    @positions.shift
    case @direction
      when "down"
        #.shift removes the first element of an array, so from def initialize the [2, 0]. we want to remove that position and add a new positon at the other end of the snake to make it appear as if it s moving
        @positions.push([head[0], head[1] + 1])
      when "up"
        @positions.push([head[0], head[1] - 1])
      when "left"
        @positions.push([head[0] - 1, head[1]])
      when "right"
        @positions.push([head[0] + 1, head[1]])
    end
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

  private

  # for when we want to call the head of the snake
  def head
    @positions.last
  end
end

snake = Snake.new

# each frame (= each second due to fps_cap 1) is an update, so this happens every second: clear, move, draw...)
update do
  # clear each time screen is refreshed/new frame, else we draw our snake on top of the existing snake
  clear
  snake.move
  snake.draw
end

on :key_down do |event|
  if ["up", "down", "left", "right"].include?(event.key)
    if snake.snake_can_change_direction_to?(event.key)
      snake.direction = event.key
    end
  end
end

show
