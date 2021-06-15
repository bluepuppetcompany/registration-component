module RegistrationComponent
  class Start
    def self.build
      instance = new
      instance
    end

    def call
      Consumers::Commands.start("registration:command")
      Consumers::Events.start("registration")

      Consumers::UserEmailAddress::Events.start("userEmailAddress", correlation: "registration")
    end
  end
end
