module RegistrationComponent
  module Consumers
    class Events
      include Consumer::Postgres

      handler Handlers::Events
    end
  end
end
