// Login and retrieve an authentication token
query "auth/login" verb=POST {
  api_group = "sistema de vendas"

  input {
    email email? filters=trim|lower
    text senha?
  }

  stack {
    db.get comerciante {
      field_name = "email"
      field_value = $input.email
      output = ["id", "created_at", "name", "email", "password"]
    } as $comerciante
  
    precondition ($comerciante != null) {
      error = "Invalid Credentials."
    }
  
    security.check_password {
      text_password = $input.senha
      hash_password = $comerciante.senha
    } as $pass_result
  
    precondition ($pass_result) {
      error = "Invalid Credentials."
    }
  
    security.create_auth_token {
      table = "comerciante"
      extras = {}
      expiration = 86400
      id = $comerciante.id
    } as $authToken
  }

  response = {authToken: $authToken}
  guid = "53I7OKojjB83V1C1MNhOcRa9TB4"
}