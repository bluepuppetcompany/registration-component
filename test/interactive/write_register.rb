require_relative './interactive_init'

registration_id = "abc"

claim_id = "aaa"

user_id = "123"

email_address = "jane@example.com"

Controls::Write::Register.(
  id: registration_id,
  claim_id: claim_id,
  user_id: user_id,
  email_address: email_address
)
