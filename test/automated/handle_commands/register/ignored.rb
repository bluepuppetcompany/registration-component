require_relative '../../automated_init'

context "Handle Commands" do
  context "Register" do
    context "Ignored" do
      handler = Handlers::Commands.new

      register = Controls::Commands::Register.example

      registration = Controls::Registration::Initiated.example

      handler.store.add(registration.id, registration)

      handler.(register)

      writer = handler.write

      initiated = writer.one_message do |event|
        event.instance_of?(Messages::Events::Initiated)
      end

      test "Initiated Event is not Written" do
        assert(initiated.nil?)
      end
    end
  end
end
