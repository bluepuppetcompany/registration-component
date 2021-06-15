module RegistrationComponent
  module Consumers
    module UserEmailAddress
      class Events
        include Consumer::Postgres

        identifier 'registration'

        handler Handlers::UserEmailAddress::Events
      end
    end
  end
end
