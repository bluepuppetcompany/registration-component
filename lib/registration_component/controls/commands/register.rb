module RegistrationComponent
  module Controls
    module Commands
      module Register
        def self.example(
          id: nil,
          claim_id: nil,
          user_id: nil,
          email_address: nil
        )
          id ||= Registration.id
          claim_id ||= ID.example
          user_id ||= User.id
          email_address ||= Registration.email_address

          register = RegistrationComponent::Messages::Commands::Register.build

          register.registration_id = id
          register.claim_id = claim_id
          register.user_id = user_id
          register.email_address = email_address
          register.time = Controls::Time::Effective.example

          register
        end
      end
    end
  end
end
