require 'rufus-scheduler'
module Lita
  module Handlers
    class VoteHandler < Handler
      on :loaded, :load_on_start
      def load_on_start(_payload)
        create_schedule
      end

      def run
        # TODO
      end

      route("hello democracy") do |response|
        response.reply("Hello from here dude")
      end

      # Receive a vote
      route(/[123], ?[123], ?[123]$/, command: false) do |response|
        user = response.user.mention_name
        card_ids = voting_sevice.get_pending_vote_card_ids(user)
        resp_msg = response.matches[0][0]
        votes = ParseVoteResponse.for(user: user, card_ids: card_ids, response: resp_msg)
        votes.each { |vote| voting_service.save_vote(vote) }
        response.reply("Muchas gracias!  Registré tu votación :+1:#{response.message}")
      end

      def ask_vote(user, cards)
        voting_service.reset_pending_votes(user)
        voting_service.store_pending_vote(user, cards.map(&:id))
        message = build_message(user, cards)
        robot.send_message(Source.new(user: user), message)
      end

      def build_message(user, cards)
        # TODO
        "Hello I'm the message"
      end

      def voting_service
        @voting_sevice ||= VotingService.new(redis: redis)
      end

      def create_schedule
        scheduler = Rufus::Scheduler.new
        scheduler.cron(ENV['DEMOCRACY_CRON']) do
          run
        end
      end

      Lita.register_handler(self)
    end
  end
end
