require './app/bullets/bullet_list.rb'
require './app/map'
require './app/player'
require './app/scope'
require './app/enemy'
require './app/lives_counter'

# Handles the game loop.
class Game
  def initialize
    @player = Player.new
    @map = Map.new
    @scope = Scope.new
    @bullets = BulletList.new
    @lives_counter = LivesCounter.new(@player)

    @frames = 0
    @difficulty = 0
  end

  def update
    @player.update
    @map.update
    @scope.update
    @bullets.update
    if @map.colliding? @player then
      @player.remove_life!
    end
    @bullets.delete_if do |bullet|
      @map.colliding? bullet
    end
    @frames += 1
    if @frames % 256 == 0 then
      @difficulty += 1
      @map.set_difficulty! @difficulty
    end
  end

  def draw
    @player.draw
    @map.draw
    @scope.draw
    @bullets.draw
    @lives_counter.draw
  end

  def button_down(button)
    case button
      when Gosu::MsLeft
        bullet = @player.fire!(@scope.x, @scope.y)
        @bullets << bullet if bullet
    end
  end
end
