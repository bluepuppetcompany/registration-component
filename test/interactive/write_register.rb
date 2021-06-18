require_relative './interactive_init'

registration_id = Identifier::UUID::Random.get

claim_id = Identifier::UUID::Random.get

user_id = Identifier::UUID::Random.get

email_address = "jane@example.com"

Controls::Write::Register.(
  id: registration_id,
  claim_id: claim_id,
  user_id: user_id,
  email_address: email_address
)
