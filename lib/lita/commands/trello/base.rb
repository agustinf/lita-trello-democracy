module Lita
  module Commands
    module Trello
      class Base < PowerTypes::Command.new
        def initialize(options)
          ::Trello.configure do |config|
            config.developer_public_key = options.developer_public_key
            config.member_token = options.member_token
          end
        end
      end
    end
  end
end
