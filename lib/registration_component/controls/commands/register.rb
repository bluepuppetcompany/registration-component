module RegistrationComponent
  module Controls
    module Commands
      module Register
        def self.example
          register = RegistrationComponent::Messages::Commands::Register.build

          register.registration_id = Registration.id
          register.user_id = User.id
          register.email_address = Registration.email_address
          register.time = Controls::Time::Effective.example

          register
        end
      end
    end
  end
end
