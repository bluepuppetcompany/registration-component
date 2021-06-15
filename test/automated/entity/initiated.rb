require_relative "../automated_init"

context "Registration" do
  context "Has Initiated Time" do
    registration = Controls::Registration::Initiated.example

    test "Is initiated" do
      assert(registration.initiated?)
    end
  end

  context "Does not Have Initiated Time" do
    registration = Controls::Registration::New.example

    test "is not initiated" do
      refute(registration.initiated?)
    end
  end
end
