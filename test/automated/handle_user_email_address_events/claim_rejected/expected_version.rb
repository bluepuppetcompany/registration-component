require_relative '../../automated_init'

context "Handle User Email Address Events" do
  context "Claim Rejected" do
    context "Expected Version" do
      handler = Handlers::UserEmailAddress::Events.new

      claim_rejected = UserEmailAddress::Client::Controls::Events::ClaimRejected.example

      registration_id = Controls::Registration.id
      registration_stream_name = "registration-#{registration_id}"
      claim_rejected.metadata.correlation_stream_name = registration_stream_name

      registration = Controls::Registration::Initiated.example

      version = Controls::Version.example

      handler.store.add(registration.id, registration, version)

      handler.(claim_rejected)

      writer = handler.write

      email_rejected = writer.one_message do |event|
        event.instance_of?(Messages::Events::EmailRejected)
      end

      test "Is entity version" do
        written_to_stream = writer.written?(email_rejected) do |_, expected_version|
          expected_version == version
        end

        assert(written_to_stream)
      end
    end
  end
end
