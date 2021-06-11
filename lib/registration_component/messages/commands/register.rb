module RegistrationComponent
  module Messages
    module Commands
      class Register
        include Messaging::Message

        attribute :registration_id, String
        attribute :user_id, String
        attribute :email_address, String
        attribute :time, String
      end
    end
  end
end
