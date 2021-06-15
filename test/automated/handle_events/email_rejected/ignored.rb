require_relative '../../automated_init'

context "Handle Events" do
  context "Email Rejected" do
    context "Ignored" do
      handler = Handlers::Events.new

      email_rejected = Controls::Events::EmailRejected.example

      registration = Controls::Registration::Cancelled.example

      handler.store.add(registration.id, registration)

      handler.(email_rejected)

      writer = handler.write

      cancelled = writer.one_message do |event|
        event.instance_of?(Messages::Events::Cancelled)
      end

      test "Cancelled Event is not Written" do
        assert(cancelled.nil?)
      end
    end
  end
end
