require "crsfml"
require "./snake_tutorial/*"

# TODO: Write documentation for `SnakeTutorial`
module SnakeTutorial
  game = Game.new
  while !game.window.done?
    game.handle_input
    game.update
    game.render
    game.restart_clock
  end
end
