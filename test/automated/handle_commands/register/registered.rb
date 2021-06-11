require_relative '../../automated_init'

context "Handle Commands" do
  context "Register" do
    context "Registered" do
      handler = Handlers::Commands.new

      processed_time = Controls::Time::Processed::Raw.example

      handler.clock.now = processed_time

      register = Controls::Commands::Register.example

      registration_id = register.registration_id or fail
      user_id = register.user_id or fail
      email_address = register.email_address or fail
      effective_time = register.time or fail

      handler.(register)

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
          assert(registered.time == effective_time)
        end

        test "processed_time" do
          processed_time_iso8601 = Clock::UTC.iso8601(processed_time)

          assert(registered.processed_time == processed_time_iso8601)
        end
      end
    end
  end
end
