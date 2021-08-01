require_relative '../automated_init'

context "Projection" do
  context "Cancelled" do
    registration = Controls::Registration::New.example

    assert(registration.cancelled_time.nil?)

    cancelled = Controls::Events::Cancelled.example

    registration_id = cancelled.registration_id or fail
    cancelled_time_iso8601 = cancelled.time or fail

    Projection.(registration, cancelled)

    test "ID is set" do
      assert(registration.id == registration_id)
    end

    test "Cancelled time is converted and copied" do
      cancelled_time = Time.parse(cancelled_time_iso8601)

      assert(registration.cancelled_time == cancelled_time)
    end
  end
end
