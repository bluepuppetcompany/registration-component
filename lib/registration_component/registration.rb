module RegistrationComponent
  class Registration
    include Schema::DataStructure

    attribute :id, String
    attribute :user_id, String
    attribute :email_address, String
    attribute :registered_time, Time

    def registered?
      !registered_time.nil?
    end
  end
end
