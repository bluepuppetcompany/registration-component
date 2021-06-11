require_relative '../automated_init'

context "Projection" do
  context "Registered" do
    registration = Controls::Registration::New.example

    assert(registration.registered_time.nil?)

    registered = Controls::Events::Registered.example

    registration_id = registered.registration_id or fail
    user_id = registered.user_id or fail
    email_address = registered.email_address or fail

    Projection.(registration, registered)

    test "ID is set" do
      assert(registration.id == registered.registration_id)
    end

    test "User ID is set" do
      assert(registration.user_id == registered.user_id)
    end

    test "Email Address is set" do
      assert(registration.email_address == registered.email_address)
    end

    test "Registered time is converted and copied" do
      registered_time = Time.parse(registered.time)

      assert(registration.registered_time == registered_time)
    end
  end
end
