require "lita"
require "redis"
require "power-types"

Lita.load_locales Dir[File.expand_path(
  File.join("..", "..", "locales", "*.yml"), __FILE__
)]

require "lita/handlers/vote_handler"

Lita::Handlers::GithubPushReceiver.template_root File.expand_path(
  File.join("..", "..", "templates"), __FILE__
)
