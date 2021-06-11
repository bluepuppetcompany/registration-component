module RegistrationComponent
  class Store
    include EntityStore

    category :registration
    entity Registration
    projection Projection
    reader MessageStore::Postgres::Read
  end
end
