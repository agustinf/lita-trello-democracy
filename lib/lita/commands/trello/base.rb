module Lita
  module Commands
    module Trello
      class Base < PowerTypes::Command.new
        def initialize(options)
          conf = options[:config]
          ::Trello.configure do |config|
            config.developer_public_key = conf.developer_public_key
            config.member_token = conf.member_token
          end
        end
      end
    end
  end
end
