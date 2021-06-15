require_relative '../../automated_init'

context "Handle Events" do
  context "Email Accepted" do
    context "Expected Version" do
      handler = Handlers::Events.new

      email_accepted = Controls::Events::EmailAccepted.example

      registration = Controls::Registration::EmailAccepted.example

      version = Controls::Version.example

      handler.store.add(email_accepted.registration_id, registration, version)

      handler.(email_accepted)

      writer = handler.write

      registered = writer.one_message do |event|
        event.instance_of?(Messages::Events::Registered)
      end

      test "Is entity version" do
        written_to_stream = writer.written?(registered) do |_, expected_version|
          expected_version == version
        end

        assert(written_to_stream)
      end
    end
  end
end
