module RegistrationComponent
  module Handlers
    class Commands
      include Log::Dependency
      include Messaging::Handle
      include Messaging::StreamName
      include Messages::Commands
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

      handle Register do |register|
        registration_id = register.registration_id

        registration, version = store.fetch(registration_id, include: :version)

        if registration.initiated?
          logger.info(tag: :ignored) { "Command ignored (Command: #{register.message_type}, Registration ID: #{registration_id}, User ID: #{register.user_id})" }
          return
        end

        time = clock.iso8601

        stream_name = stream_name(registration_id)

        initiated = Initiated.follow(register)
        initiated.processed_time = time

        write.(initiated, stream_name, expected_version: version)
      end
    end
  end
end
