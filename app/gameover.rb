require 'gosu'
# display the gameover screen
class GameOver
  GAMEOVER_Z_INDEX = 1

  X_OFFSET_GAMEOVER = 250
  Y_OFFSET_MESSAGE = 60

  SCALE_X = 1.0
  SCALE_Y = 1.0

  def initialize
    @message_font = Gosu::Font.new(60)
    @other_font = Gosu::Font.new(10)
  end

  def button_down(button)
    case button
    when Gosu::KbReturn then
        Global.instance.window.state = Menu.new
    end
  end

  def draw
    @message_font.draw("G A M E  O V E R", ApplicationWindow::WINDOW_WIDTH / 2 - X_OFFSET_GAMEOVER, ApplicationWindow::WINDOW_HEIGHT / 2, GAMEOVER_Z_INDEX, SCALE_X, SCALE_Y,
      Gosu::Color::WHITE)
    @other_font.draw("Press RETURN to go back to the menu", ApplicationWindow::WINDOW_WIDTH / 2 - 250, (ApplicationWindow::WINDOW_HEIGHT / 2) + Y_OFFSET_MESSAGE, GAMEOVER_Z_INDEX, SCALE_X, SCALE_Y,
      Gosu::Color::WHITE)
  end
end
