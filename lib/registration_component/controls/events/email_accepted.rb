module RegistrationComponent
  module Controls
    module Events
      module EmailAccepted
        def self.example
          email_accepted = RegistrationComponent::Messages::Events::EmailAccepted.build

          email_accepted.registration_id = Registration.id
          email_accepted.user_id = User.id
          email_accepted.email_address = Registration.email_address
          email_accepted.time = Controls::Time::Effective.example
          email_accepted.processed_time = Controls::Time::Processed.example

          email_accepted
        end
      end
    end
  end
end
