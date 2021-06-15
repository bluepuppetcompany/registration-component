module RegistrationComponent
  module Controls
    module Write
      module Register
        def self.call(
          id: nil,
          claim_id: nil,
          user_id: nil,
          email_address: nil
        )
          id ||= Registration.id
          claim_id ||= ID.example
          user_id ||= User.id
          email_address ||= Registration.email_address

          register = Commands::Register.example(
            id: id,
            claim_id: claim_id,
            user_id: user_id,
            email_address: email_address
          )

          command_stream_name = Messaging::StreamName.command_stream_name(id, "registration")

          Messaging::Postgres::Write.(register, command_stream_name)
        end
      end
    end
  end
end
