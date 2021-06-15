require_relative '../../automated_init'

context "Handle Events" do
  context "Initiated" do
    context "Claim" do
      handler = Handlers::Events.new

      processed_time = Controls::Time::Processed::Raw.example

      handler.clock.now = processed_time

      initiated = Controls::Events::Initiated.example

      registration_id = initiated.registration_id or fail
      user_id = initiated.user_id or fail
      email_address = initiated.email_address or fail

      encoded_email_address = UserEmailAddress::Client::Controls::UserEmailAddress.encoded_email_address

      handler.(initiated)

      writer = handler.write

      claim = writer.one_message do |command|
        command.instance_of?(UserEmailAddress::Client::Messages::Commands::Claim)
      end

      test "Claim command is written" do
        refute(claim.nil?)
      end

      test "Written to the user email address stream" do
        written_to_stream = writer.written?(claim) do |stream_name|
          stream_name == "userEmailAddress:command-#{encoded_email_address}"
        end

        assert(written_to_stream)
      end

      context "Attributes" do
        test "claim_id" do
          assert(claim.claim_id == registration_id)
        end

        test "encoded_email_address" do
          assert(claim.encoded_email_address == encoded_email_address)
        end

        test "email_address" do
          assert(claim.email_address == email_address)
        end

        test "user_id" do
          assert(claim.user_id == user_id)
        end

        test "time" do
          processed_time_iso8601 = Clock::UTC.iso8601(processed_time)

          assert(claim.time == processed_time_iso8601)
        end
      end
    end
  end
end
