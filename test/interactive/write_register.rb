require_relative './interactive_init'

registration_id = "abc"

user_id = "123"

email_address = "jane@example.com"

Controls::Write::Register.(
  id: registration_id,
  user_id: user_id,
  email_address: email_address
)
