require "trello"
require "lita"
require "redis"
require "power-types"

Lita.load_locales Dir[File.expand_path(
  File.join("..", "..", "locales", "*.yml"), __FILE__
)]

require "lita/commands/trello/base"
require "lita/commands/trello/get_random_cards"
require "lita/handlers/vote_handler"

Lita::Handlers::VoteHandler.template_root File.expand_path(
  File.join("..", "..", "templates"), __FILE__
)
