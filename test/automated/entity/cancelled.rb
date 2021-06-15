require_relative "../automated_init"

context "Registration" do
  context "Has Cancelled Time" do
    registration = Controls::Registration::Cancelled.example

    test "Is cancelled" do
      assert(registration.cancelled?)
    end
  end

  context "Does not Have Cancelled Time" do
    registration = Controls::Registration.example

    test "is not cancelled" do
      refute(registration.cancelled?)
    end
  end
end
