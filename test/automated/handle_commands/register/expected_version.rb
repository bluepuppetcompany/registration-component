require_relative '../../automated_init'

context "Handle Commands" do
  context "Register" do
    context "Expected Version" do
      handler = Handlers::Commands.new

      register = Controls::Commands::Register.example

      registration = Controls::Registration::New.example

      version = Controls::Version.example

      handler.store.add(register.registration_id, registration, version)

      handler.(register)

      writer = handler.write

      registered = writer.one_message do |event|
        event.instance_of?(Messages::Events::Registered)
      end

      test "Is entity version" do
        written_to_stream = writer.written?(registered) do |_, expected_version|
          expected_version == version
        end

        assert(written_to_stream)
      end
    end
  end
end
