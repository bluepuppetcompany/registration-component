require_relative '../../automated_init'

context "Handle Commands" do
  context "Register" do
    context "Ignored" do
      handler = Handlers::Commands.new

      register = Controls::Commands::Register.example

      registration = Controls::Registration::Registered.example

      handler.store.add(registration.id, registration)

      handler.(register)

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
