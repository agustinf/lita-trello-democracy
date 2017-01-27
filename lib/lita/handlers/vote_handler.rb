require 'rufus-scheduler'
module Lita
  module Handlers
    class VoteHandler < Handler
      on :loaded, :load_on_start
      config :trello_config, required: true do
        config :developer_public_key, type: String
        config :member_token, type: String
      end


      def load_on_start(_payload)
        create_schedule
      end

      def run(voters)
        all_cards = Lita::Commands::Trello::GetCards.for(config: config.trello_config)
        AttachVotesToCards.for(cards: all_cards, redis: redis)
        SyncCards.for(cards: all_cards, redis: redis)
        voters.each do |user|
          vote_cards = SelectVotingCards.for(user: user, cards: all_cards)
          ask_vote(user, vote_cards)
        end
      end

      route(/please\sask\svote\sfrom\s+(.+)/, command: true) do |response|
        user = response.matches[0][0]
        voters = (user == "everyone") ? get_voters : [user]
        run(voters)
      end

      route(/please\sshow\svoters/, command: true) do |response|
        message = "OK, here is the voter list:\n"
        message += get_voters.join(", ")
        response.reply(message)
      end

      route("hello democracy") do |response|
        response.reply("Hello from here dude")
      end

      # Receive a vote
      route(/[123], ?[123], ?[123]$/, command: true) do |response|
        response.reply("Procesando tu votación... :clock1:")
        user = response.user.mention_name
        card_ids = voting_service.get_pending_vote_card_ids(user)
        resp_msg = response.matches.first
        votes = ParseVoteResponse.for(user: user, card_ids: card_ids, response: resp_msg)
        votes.each { |vote| voting_service.save_vote(vote) }
        voting_service.reset_pending_votes(user)
        unsorted_cards = Lita::Commands::Trello::GetCards.for(config: config.trello_config)
        sorted_cards = run_sorting
        response.reply("Listo, muchas gracias! Registré tu votación :+1:")
        response.reply("De las #{unsorted_cards.length} tarjetas, las que votaste han quedado rankeadas de la siguiente manera:")
        response.reply GenerateRankingMessage.for(sorted_cards: sorted_cards, unsorted_cards: unsorted_cards, card_ids: card_ids)
        send_sorted_cards_to_trello sorted_cards
      end

      route(/please\sconsider\svoter\s+(.+)/, command: true) do |response|
        voter_name = response.matches[0][0]
        add_to_voters(voter_name)
        response.reply("Ok dude. #{voter_name} is on the voters list")
      end

      route(/please\sremove\svoter\s+(.+)/, command: true) do |response|
        voter_name = response.matches[0][0]
        remove_from_voters(voter_name)
        response.reply("Ok dude. #{voter_name} has been removed from the voters list")
      end

      def run_sorting
        SortCards.for(cards: get_cards)
      end

      def send_sorted_cards_to_trello(sorted_cards)
        Lita::Commands::Trello::SortCards.for(cards: sorted_cards, config: config.trello_config)
      end

      def ask_vote(user, cards)
        voting_service.reset_pending_votes(user)
        voting_service.store_pending_vote(user, cards.map(&:id))
        message = build_message(user, cards)
        slack_user = Lita::User.find_by_mention_name(user)
        robot.send_message(Source.new(user: slack_user), message)
      end

      def build_message(user, cards)
        message = "Hola #{user}, me haces un favor? :peanutbutterjellytime:\n" +
            " Ordena estas 3 tarjetas de acuerdo a la prioridad " +
            "que piensas tienen para Platanus en este momento.\n"
        cards.each_with_index { |card, index | message += "\n#{(index + 1)}. #{card.name} #{card.short_url}" }
        message + "\nEj. #{[1,2,3].shuffle.join(", ")}"
      end

      def get_cards
        cards = redis.smembers("cards").map { |card_json| Card.from_dump(card_json) }
        AttachVotesToCards.for(cards: cards, redis: redis)
        cards
      end

      def voting_service
        @voting_service ||= VotingService.new(redis: redis)
      end

      def get_voters
        redis.smembers("voters") || []
      end

      def add_to_voters(mention_name)
        redis.sadd("voters", mention_name)
      end

      def remove_from_voters(mention_name)
        redis.srem("voters", mention_name)
      end

      def create_schedule
        scheduler = Rufus::Scheduler.new
        scheduler.cron(ENV['DEMOCRACY_CRON']) do
          run(get_voters)
        end
      end

      Lita.register_handler(self)
    end
  end
end
