require_relative '../../automated_init'

context "Handle Events" do
  context "Email Accepted" do
    context "Ignored" do
      handler = Handlers::Events.new

      email_accepted = Controls::Events::EmailAccepted.example

      registration = Controls::Registration::Registered.example

      handler.store.add(registration.id, registration)

      handler.(email_accepted)

      writer = handler.write

      registered = writer.one_message do |event|
        event.instance_of?(Messages::Events::Registered)
      end

      test "Registered Event is not Written" do
        assert(registered.nil?)
      end
    end
  end
end
