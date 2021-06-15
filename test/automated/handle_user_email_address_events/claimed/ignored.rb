require_relative '../../automated_init'

context "Handle User Email Address Events" do
  context "Claimed" do
    context "Ignored" do
      handler = Handlers::UserEmailAddress::Events.new

      claimed = UserEmailAddress::Client::Controls::Events::Claimed.example

      registration_id = Controls::Registration.id
      registration_stream_name = "registration-#{registration_id}"
      claimed.metadata.correlation_stream_name = registration_stream_name

      registration = Controls::Registration::EmailAccepted.example

      handler.store.add(registration.id, registration)

      handler.(claimed)

      writer = handler.write

      email_accepted = writer.one_message do |event|
        event.instance_of?(Messages::Events::EmailAccepted)
      end

      test "Email Accepted Event is not Written" do
        assert(email_accepted.nil?)
      end
    end
  end
end
