require "trello"
require "lita"
require "redis"
require "power-types"

Lita.load_locales Dir[File.expand_path(
  File.join("..", "..", "locales", "*.yml"), __FILE__
)]

require "lita/commands/trello/base"
require "lita/models/card"
require "lita/models/vote"
require "lita/commands/trello/get_cards"
require "lita/commands/trello/sort_cards"
require "lita/commands/sort_cards"
require "lita/commands/parse_vote_response"
require "lita/commands/attach_votes_to_cards"
require "lita/commands/select_voting_cards"
require "lita/commands/generate_ranking_message"
require "lita/handlers/vote_handler"
require "lita/services/voting_service"

Lita::Handlers::VoteHandler.template_root File.expand_path(
  File.join("..", "..", "templates"), __FILE__
)
