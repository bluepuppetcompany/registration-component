require_relative '../../automated_init'

context "Handle User Email Address Events" do
  context "Claim Rejected" do
    context "Ignored" do
      handler = Handlers::UserEmailAddress::Events.new

      claim_rejected = UserEmailAddress::Client::Controls::Events::ClaimRejected.example

      registration_id = Controls::Registration.id
      registration_stream_name = "registration-#{registration_id}"
      claim_rejected.metadata.correlation_stream_name = registration_stream_name

      registration = Controls::Registration::EmailRejected.example

      handler.store.add(registration.id, registration)

      handler.(claim_rejected)

      writer = handler.write

      email_rejected = writer.one_message do |event|
        event.instance_of?(Messages::Events::EmailRejected)
      end

      test "Email Rejected Event is not Written" do
        assert(email_rejected.nil?)
      end
    end
  end
end
