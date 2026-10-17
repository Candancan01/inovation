// Signup and retrieve an authentication token
query "auth/signup" verb=POST {
  api_group = "sistema de vendas"

  input {
    text nome?
    email email? filters=lower|trim
    password senha?
  }

  stack {
    db.get comerciante {
      field_name = "email"
      field_value = $input.email
    } as $comerciante
  
    precondition ($comerciante == null) {
      error_type = "accessdenied"
      error = "This account is already in use."
    }
  
    db.add comerciante {
      enforce_hidden_fields = false
      data = {
        nome : $input.nome
        email: $input.email
        senha: $input.senha
      }
    } as $comerciante
  
    security.create_auth_token {
      table = "comerciante"
      extras = {}
      expiration = 86400
      id = $comerciante.id
    } as $authToken
  }

  response = {authToken: $authToken}
  guid = "mec8R-uAGarldkz5RVn2K6wOMUQ"
}