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

      handle EmailAccepted do |email_accepted|
        registration_id = email_accepted.registration_id

        registration, version = store.fetch(registration_id, include: :version)

        if registration.registered?
          logger.info(tag: :ignored) { "Event ignored (Event: #{email_accepted.message_type}, Registration ID: #{registration_id}, User ID: #{email_accepted.user_id})" }
          return
        end

        time = clock.iso8601

        stream_name = stream_name(registration_id)

        registered = Registered.follow(email_accepted, exclude: [
          :processed_time
        ])
        registered.time = time

        write.(registered, stream_name, expected_version: version)
      end

      handle EmailRejected do |email_rejected|
        registration_id = email_rejected.registration_id

        registration, version = store.fetch(registration_id, include: :version)

        if registration.cancelled?
          logger.info(tag: :ignored) { "Event ignored (Event: #{email_rejected.message_type}, Registration ID: #{registration_id}, User ID: #{email_rejected.user_id})" }
          return
        end

        time = clock.iso8601

        stream_name = stream_name(registration_id)

        cancelled = Cancelled.follow(email_rejected, exclude: [
          :processed_time
        ])
        cancelled.time = time

        write.(cancelled, stream_name, expected_version: version)
      end
    end
  end
end
