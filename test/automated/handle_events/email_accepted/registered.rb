require_relative '../../automated_init'

context "Handle Events" do
  context "Email Accepted" do
    context "Registered" do
      handler = Handlers::Events.new

      processed_time = Controls::Time::Processed::Raw.example

      handler.clock.now = processed_time

      email_accepted = Controls::Events::EmailAccepted.example

      registration_id = email_accepted.registration_id or fail
      user_id = email_accepted.user_id or fail
      email_address = email_accepted.email_address or fail

      handler.(email_accepted)

      writer = handler.write

      registered = writer.one_message do |event|
        event.instance_of?(Messages::Events::Registered)
      end

      test "Registered Event is Written" do
        refute(registered.nil?)
      end

      test "Written to the registration stream" do
        written_to_stream = writer.written?(registered) do |stream_name|
          stream_name == "registration-#{registration_id}"
        end

        assert(written_to_stream)
      end

      context "Attributes" do
        test "registration_id" do
          assert(registered.registration_id == registration_id)
        end

        test "user_id" do
          assert(registered.user_id == user_id)
        end

        test "email_address" do
          assert(registered.email_address == email_address)
        end

        test "time" do
          processed_time_iso8601 = Clock::UTC.iso8601(processed_time)

          assert(registered.time == processed_time_iso8601)
        end
      end
    end
  end
end
