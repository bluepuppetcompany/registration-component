module RegistrationComponent
  module EncodeEmailAddress
    def encode_email_address(email_address)
      downcased_email_address = email_address.downcase
      Digest::SHA256.hexdigest(downcased_email_address)
    end
  end
end
