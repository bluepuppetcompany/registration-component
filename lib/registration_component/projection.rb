module RegistrationComponent
  class Projection
    include EntityProjection
    include Messages::Events

    entity_name :registration

    apply Initiated do |initiated|
      registration.id = initiated.registration_id
      registration.user_id = initiated.user_id
      registration.email_address = initiated.email_address
      registration.initiated_time = Clock.parse(initiated.time)
    end

    apply EmailAccepted do |email_accepted|
      registration.id = email_accepted.registration_id
      registration.email_accepted_time = Clock.parse(email_accepted.time)
    end

    apply EmailRejected do |email_rejected|
      registration.id = email_rejected.registration_id
      registration.email_rejected_time = Clock.parse(email_rejected.time)
    end

    apply Registered do |registered|
      registration.id = registered.registration_id
      registration.registered_time = Clock.parse(registered.time)
    end

    apply Cancelled do |cancelled|
      registration.id = cancelled.registration_id
      registration.cancelled_time = Clock.parse(cancelled.time)
    end
  end
end
