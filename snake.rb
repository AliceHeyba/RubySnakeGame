require "ruby2d"

set background: "navy"
#fps cap is how quickly the frame reloads. ie. in def move we want the first position of the snake to be deleted when the new position is created (to create a movement: one position gone & one position added). if we dont set fps cap to 1 then this happens so quickly that our entire snake body/all positions get deleted and we don't see anything on the screen. if it s fps cap: 1 1 position/body piece disappears (....) per second and we can follow it on our screen.
set fps_cap: 1

#window width is 640 by default --> grid size 20 x 32 times
# window height is 480
GRID_SIZE = 20

# position first number in position array is first number x axis (horizontal), 2nd number y axis (vertical)

class Snake

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
      Square.new(x: position[0] * GRID_SIZE, y: position[1] * GRID_SIZE - 1, size: GRID_SIZE, color: "white")
    end
  end

  #
  def move
    case @direction
      when "down"
        #.shift removes the first element of an array, so from def initialize the [2, 0]. we want to remove that position and add a new positon at the other end of the snake to make it appear as if it s moving
        @positions.shift
    end
  end
end
snake = Snake.new
snake.draw

show
