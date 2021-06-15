module RegistrationComponent
  class Registration
    include Schema::DataStructure

    attribute :id, String
    attribute :user_id, String
    attribute :email_address, String

    attribute :initiated_time, Time
    attribute :email_accepted_time, Time
    attribute :email_rejected_time, Time
    attribute :registered_time, Time
    attribute :cancelled_time, Time

    def initiated?
      !initiated_time.nil?
    end

    def email_accepted?
      !email_accepted_time.nil?
    end

    def email_rejected?
      !email_rejected_time.nil?
    end

    def registered?
      !registered_time.nil?
    end

    def cancelled?
      !cancelled_time.nil?
    end
  end
end
