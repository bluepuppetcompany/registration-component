module RegistrationComponent
  module Messages
    module Events
      class Initiated
        include Messaging::Message

        attribute :registration_id, String
        attribute :claim_id, String
        attribute :user_id, String
        attribute :email_address, String
        attribute :time, String
        attribute :processed_time, String
      end
    end
  end
end
