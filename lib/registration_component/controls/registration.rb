module RegistrationComponent
  module Controls
    module Registration
      def self.example
        registration = RegistrationComponent::Registration.build

        registration.id = id
        registration.initiated_time = Time::Effective::Raw.example

        registration
      end

      def self.id
        ID.example(increment: id_increment)
      end

      def self.id_increment
        11
      end

      def self.email_address
        "jane@example.com"
      end

      module New
        def self.example
          RegistrationComponent::Registration.build
        end
      end

      module Initiated
        def self.example
          Registration.example
        end
      end

      module EmailAccepted
        def self.example
          registration = Registration.example
          registration.email_accepted_time = Time::Effective::Raw.example
          registration
        end
      end

      module EmailRejected
        def self.example
          registration = Registration.example
          registration.email_rejected_time = Time::Effective::Raw.example
          registration
        end
      end

      module Registered
        def self.example
          registration = Registration.example
          registration.registered_time = Time::Effective::Raw.example
          registration
        end
      end

      module Cancelled
        def self.example
          registration = Registration.example
          registration.cancelled_time = Time::Effective::Raw.example
          registration
        end
      end
    end
  end
end
