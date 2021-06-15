require_relative "../automated_init"

context "Registration" do
  context "Has Email Accepted Time" do
    registration = Controls::Registration::EmailAccepted.example

    test "Is email_accepted" do
      assert(registration.email_accepted?)
    end
  end

  context "Does not Have Email Accepted Time" do
    registration = Controls::Registration.example

    test "is not email_accepted" do
      refute(registration.email_accepted?)
    end
  end
end
