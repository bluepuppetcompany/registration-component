require_relative '../../automated_init'

context "Handle User Email Address Events" do
  context "Claimed" do
    context "Expected Version" do
      handler = Handlers::UserEmailAddress::Events.new

      claimed = UserEmailAddress::Client::Controls::Events::Claimed.example

      registration_id = Controls::Registration.id
      registration_stream_name = "registration-#{registration_id}"
      claimed.metadata.correlation_stream_name = registration_stream_name

      registration = Controls::Registration::Initiated.example

      version = Controls::Version.example

      handler.store.add(registration.id, registration, version)

      handler.(claimed)

      writer = handler.write

      email_accepted = writer.one_message do |event|
        event.instance_of?(Messages::Events::EmailAccepted)
      end

      test "Is entity version" do
        written_to_stream = writer.written?(email_accepted) do |_, expected_version|
          expected_version == version
        end

        assert(written_to_stream)
      end
    end
  end
end
