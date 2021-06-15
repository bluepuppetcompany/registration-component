require_relative '../../automated_init'

context "Handle User Email Address Events" do
  context "Claim Rejected" do
    context "Email Rejected" do
      handler = Handlers::UserEmailAddress::Events.new

      processed_time = Controls::Time::Processed::Raw.example

      handler.clock.now = processed_time

      claim_rejected = UserEmailAddress::Client::Controls::Events::ClaimRejected.example

      registration_id = Controls::Registration.id
      registration_stream_name = "registration-#{registration_id}"
      claim_rejected.metadata.correlation_stream_name = registration_stream_name

      user_id = claim_rejected.user_id or fail
      email_address = claim_rejected.email_address or fail
      effective_time = claim_rejected.time or fail

      handler.(claim_rejected)

      writer = handler.write

      email_rejected = writer.one_message do |event|
        event.instance_of?(Messages::Events::EmailRejected)
      end

      test "Email Rejected Event is Written" do
        refute(email_rejected.nil?)
      end

      test "Written to the registration stream" do
        written_to_stream = writer.written?(email_rejected) do |stream_name|
          stream_name == registration_stream_name
        end

        assert(written_to_stream)
      end

      context "Attributes" do
        test "registration_id" do
          assert(email_rejected.registration_id == registration_id)
        end

        test "user_id" do
          assert(email_rejected.user_id == user_id)
        end

        test "email_address" do
          assert(email_rejected.email_address == email_address)
        end

        test "time" do
          assert(email_rejected.time == effective_time)
        end

        test "processed_time" do
          processed_time_iso8601 = Clock::UTC.iso8601(processed_time)

          assert(email_rejected.processed_time == processed_time_iso8601)
        end
      end
    end
  end
end
