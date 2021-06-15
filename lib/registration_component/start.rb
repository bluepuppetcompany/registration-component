module RegistrationComponent
  class Start
    def self.build
      instance = new
      instance
    end

    def call
      Consumers::Commands.start("registration:command")
      Consumers::Events.start("registration")
    end
  end
end
