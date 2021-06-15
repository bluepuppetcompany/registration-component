require_relative '../../automated_init'

context "Handle Events" do
  context "Email Rejected" do
    context "Cancelled" do
      handler = Handlers::Events.new

      processed_time = Controls::Time::Processed::Raw.example

      handler.clock.now = processed_time

      email_rejected = Controls::Events::EmailRejected.example

      registration_id = email_rejected.registration_id or fail
      user_id = email_rejected.user_id or fail
      email_address = email_rejected.email_address or fail

      handler.(email_rejected)

      writer = handler.write

      cancelled = writer.one_message do |event|
        event.instance_of?(Messages::Events::Cancelled)
      end

      test "Cancelled Event is Written" do
        refute(cancelled.nil?)
      end

      test "Written to the registration stream" do
        written_to_stream = writer.written?(cancelled) do |stream_name|
          stream_name == "registration-#{registration_id}"
        end

        assert(written_to_stream)
      end

      context "Attributes" do
        test "registration_id" do
          assert(cancelled.registration_id == registration_id)
        end

        test "user_id" do
          assert(cancelled.user_id == user_id)
        end

        test "email_address" do
          assert(cancelled.email_address == email_address)
        end

        test "time" do
          processed_time_iso8601 = Clock::UTC.iso8601(processed_time)

          assert(cancelled.time == processed_time_iso8601)
        end
      end
    end
  end
end
