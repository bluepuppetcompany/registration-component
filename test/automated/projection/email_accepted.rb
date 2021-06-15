require_relative '../automated_init'

context "Projection" do
  context "Email Accepted" do
    registration = Controls::Registration::New.example

    assert(registration.email_accepted_time.nil?)

    email_accepted = Controls::Events::EmailAccepted.example

    registration_id = email_accepted.registration_id or fail

    Projection.(registration, email_accepted)

    test "ID is set" do
      assert(registration.id == email_accepted.registration_id)
    end

    test "Email Accepted time is converted and copied" do
      email_accepted_time = Time.parse(email_accepted.time)

      assert(registration.email_accepted_time == email_accepted_time)
    end
  end
end
