module RegistrationComponent
  module Controls
    module Events
      module Cancelled
        def self.example
          cancelled = RegistrationComponent::Messages::Events::Cancelled.build

          cancelled.registration_id = Registration.id
          cancelled.user_id = User.id
          cancelled.email_address = Registration.email_address
          cancelled.time = Controls::Time::Effective.example
          cancelled.processed_time = Controls::Time::Processed.example

          cancelled
        end
      end
    end
  end
end
