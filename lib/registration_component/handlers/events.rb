module RegistrationComponent
  module Handlers
    class Events
      include Log::Dependency
      include Messaging::Handle
      include Messaging::StreamName
      include EncodeEmailAddress
      include Messages::Events
      include UserEmailAddress::Client::Messages::Commands

      dependency :write, Messaging::Postgres::Write
      dependency :clock, Clock::UTC
      dependency :store, Store

      def configure
        Messaging::Postgres::Write.configure(self)
        Clock::UTC.configure(self)
        Store.configure(self)
      end

      category :registration

      handle Initiated do |initiated|
        claim_id = initiated.claim_id
        user_id = initiated.user_id
        email_address = initiated.email_address
        encoded_email_address = encode_email_address(email_address)

        time = clock.iso8601

        claim = Claim.new
        claim.metadata.follow(initiated.metadata)

        claim.claim_id = claim_id
        claim.encoded_email_address = encoded_email_address
        claim.email_address = email_address
        claim.user_id = user_id
        claim.time = time

        stream_name = "userEmailAddress:command-#{encoded_email_address}"

        write.(claim, stream_name)
      end
    end
  end
end
