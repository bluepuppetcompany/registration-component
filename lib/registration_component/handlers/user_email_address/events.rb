module RegistrationComponent
  module Handlers
    module UserEmailAddress
      class Events
        include Log::Dependency
        include Messaging::Handle
        include Messaging::StreamName
        include Messages::Events

        dependency :write, Messaging::Postgres::Write
        dependency :clock, Clock::UTC
        dependency :store, Store

        def configure
          Messaging::Postgres::Write.configure(self)
          Clock::UTC.configure(self)
          Store.configure(self)
        end

        category :registration

        handle ::UserEmailAddress::Client::Messages::Events::Claimed do |claimed|
          correlation_stream_name = claimed.metadata.correlation_stream_name
          registration_id = Messaging::StreamName.get_id(correlation_stream_name)

          registration, version = store.fetch(registration_id, include: :version)

          if registration.email_accepted?
            logger.info(tag: :ignored) { "Event ignored (Event: #{claimed.message_type}, Registration ID: #{registration_id}, User ID: #{claimed.user_id})" }
            return
          end

          time = clock.iso8601

          stream_name = stream_name(registration_id)

          email_accepted = EmailAccepted.follow(claimed, exclude: [
            :claim_id,
            :encoded_email_address,
            :sequence
          ])
          email_accepted.registration_id = registration_id
          email_accepted.processed_time = time

          write.(email_accepted, stream_name, expected_version: version)
        end

        handle ::UserEmailAddress::Client::Messages::Events::ClaimRejected do |claim_rejected|
          correlation_stream_name = claim_rejected.metadata.correlation_stream_name
          registration_id = Messaging::StreamName.get_id(correlation_stream_name)

          registration, version = store.fetch(registration_id, include: :version)

          if registration.email_rejected?
            logger.info(tag: :ignored) { "Event ignored (Event: #{claim_rejected.message_type}, Registration ID: #{registration_id}, User ID: #{claim_rejected.user_id})" }
            return
          end

          time = clock.iso8601

          stream_name = stream_name(registration_id)

          email_rejected = EmailRejected.follow(claim_rejected, exclude: [
            :claim_id,
            :encoded_email_address,
            :sequence
          ])
          email_rejected.registration_id = registration_id
          email_rejected.processed_time = time

          write.(email_rejected, stream_name, expected_version: version)
        end
      end
    end
  end
end
