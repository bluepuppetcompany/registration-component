require_relative '../automated_init'

context "Projection" do
  context "Initiated" do
    registration = Controls::Registration::New.example

    assert(registration.initiated_time.nil?)

    initiated = Controls::Events::Initiated.example

    registration_id = initiated.registration_id or fail
    user_id = initiated.user_id or fail
    email_address = initiated.email_address or fail
    initiated_time_iso8601 = initiated.time or fail

    Projection.(registration, initiated)

    test "ID is set" do
      assert(registration.id == registration_id)
    end

    test "User ID is set" do
      assert(registration.user_id == user_id)
    end

    test "Email Address is set" do
      assert(registration.email_address == email_address)
    end

    test "Initiated time is converted and copied" do
      initiated_time = Time.parse(initiated_time_iso8601)

      assert(registration.initiated_time == initiated_time)
    end
  end
end
