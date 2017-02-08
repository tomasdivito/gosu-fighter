require 'matrix'

require "./app/sprites"
require './app/bullets/linear_bullet.rb'
require './app/gameover' # in order for the gameover screen to appear

# The game player character.
class Player
  attr_reader :lives

  WIDTH = 30
  HEIGHT = 25

  # Up / Down movement speed.
  STARTING_SPEED = 3

  BULLET_SPEED = 6

  PLAYER_Z_ORDER = 10

  DEFAULT_COLOR = 0xff_ffffff

  STARTING_LIVES = 5

  def initialize
    @sprite = Sprites::PLAYER
    @pixel = Sprites::PIXEL

    @state = :alive
    @color = DEFAULT_COLOR
    @immunity_frame = 0

    @lives = STARTING_LIVES

    @speed = STARTING_SPEED

    # Top left coordinates.
    @x = 10
    @y = 320
  end

  def collision_points
    [@top_aft, @bottom_aft, @nose]
  end

  def remove_life!
    if @state != :immune
      @lives -= 1
      die! if @lives == 0
      @state = :immune
    end
  end

  def die!
    Global.instance.window.state = GameOver.new
  end

  def lives
    return @lives.to_s
  end

  def fire!(x, y)
    return if @state == :dead
    LinearBullet.new @x, @y, *Vector[x - @x, y - @y].normalize * BULLET_SPEED
  end

  def update
    case @state
    when :alive
      move
    when :immune
      move

      @color -= 100 if @color > 0
      if @immunity_frame < 120
        @immunity_frame += 1
      else
        @state = :alive
        @immunity_frame = 0
      end
    end
  end

  def draw
    @sprite.draw @x, @y, PLAYER_Z_ORDER, 1, 1, @color
  end

  private
  def recalculate_collision_points!
    @top_aft = [@x + 5, @y]
    @bottom_aft = [@x + 5, @y + HEIGHT]
    @nose = [@x + WIDTH, @y + HEIGHT / 2]
  end

  private
  def move
    delta = 0
    if Gosu::button_down? Gosu::KbW then
      delta -= 1
    end
    if Gosu::button_down? Gosu::KbS then
      delta += 1
    end

    @y += delta * @speed
    @y = [@y, ApplicationWindow::WINDOW_HEIGHT - @sprite.height].min
    @y = [@y, 0].max

    recalculate_collision_points!
  end

end
