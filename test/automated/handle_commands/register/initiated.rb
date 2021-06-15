require_relative '../../automated_init'

context "Handle Commands" do
  context "Register" do
    context "Initiated" do
      handler = Handlers::Commands.new

      processed_time = Controls::Time::Processed::Raw.example

      handler.clock.now = processed_time

      register = Controls::Commands::Register.example

      registration_id = register.registration_id or fail
      claim_id = register.claim_id or fail
      user_id = register.user_id or fail
      email_address = register.email_address or fail
      effective_time = register.time or fail

      registration_stream_name = "registration-#{registration_id}"

      handler.(register)

      writer = handler.write

      initiated = writer.one_message do |event|
        event.instance_of?(Messages::Events::Initiated)
      end

      test "Initiated Event is Written" do
        refute(initiated.nil?)
      end

      test "Written to the registration stream" do
        written_to_stream = writer.written?(initiated) do |stream_name|
          stream_name == registration_stream_name
        end

        assert(written_to_stream)
      end

      context "Attributes" do
        test "registration_id" do
          assert(initiated.registration_id == registration_id)
        end

        test "claim_id" do
          assert(initiated.claim_id == claim_id)
        end

        test "user_id" do
          assert(initiated.user_id == user_id)
        end

        test "email_address" do
          assert(initiated.email_address == email_address)
        end

        test "time" do
          assert(initiated.time == effective_time)
        end

        test "processed_time" do
          processed_time_iso8601 = Clock::UTC.iso8601(processed_time)

          assert(initiated.processed_time == processed_time_iso8601)
        end
      end

      context "Metadata" do
        test "Correlates with registration stream name" do
          assert(initiated.metadata.correlates?(registration_stream_name))
        end
      end
    end
  end
end
