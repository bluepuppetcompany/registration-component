require_relative '../../automated_init'

context "Handle Events" do
  context "Email Rejected" do
    context "Expected Version" do
      handler = Handlers::Events.new

      email_rejected = Controls::Events::EmailRejected.example

      registration = Controls::Registration::EmailRejected.example

      version = Controls::Version.example

      handler.store.add(email_rejected.registration_id, registration, version)

      handler.(email_rejected)

      writer = handler.write

      cancelled = writer.one_message do |event|
        event.instance_of?(Messages::Events::Cancelled)
      end

      test "Is entity version" do
        written_to_stream = writer.written?(cancelled) do |_, expected_version|
          expected_version == version
        end

        assert(written_to_stream)
      end
    end
  end
end
