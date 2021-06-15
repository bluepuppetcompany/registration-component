require_relative '../../automated_init'

context "Handle User Email Address Events" do
  context "Claimed" do
    context "Email Accepted" do
      handler = Handlers::UserEmailAddress::Events.new

      processed_time = Controls::Time::Processed::Raw.example

      handler.clock.now = processed_time

      claimed = UserEmailAddress::Client::Controls::Events::Claimed.example

      registration_id = Controls::Registration.id
      registration_stream_name = "registration-#{registration_id}"
      claimed.metadata.correlation_stream_name = registration_stream_name

      user_id = claimed.user_id or fail
      email_address = claimed.email_address or fail
      effective_time = claimed.time or fail

      handler.(claimed)

      writer = handler.write

      email_accepted = writer.one_message do |event|
        event.instance_of?(Messages::Events::EmailAccepted)
      end

      test "Email Accepted Event is Written" do
        refute(email_accepted.nil?)
      end

      test "Written to the registration stream" do
        written_to_stream = writer.written?(email_accepted) do |stream_name|
          stream_name == registration_stream_name
        end

        assert(written_to_stream)
      end

      context "Attributes" do
        test "registration_id" do
          assert(email_accepted.registration_id == registration_id)
        end

        test "user_id" do
          assert(email_accepted.user_id == user_id)
        end

        test "email_address" do
          assert(email_accepted.email_address == email_address)
        end

        test "time" do
          assert(email_accepted.time == effective_time)
        end

        test "processed_time" do
          processed_time_iso8601 = Clock::UTC.iso8601(processed_time)

          assert(email_accepted.processed_time == processed_time_iso8601)
        end
      end
    end
  end
end
