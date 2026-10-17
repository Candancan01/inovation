// Get the record belonging to the authentication token
query "auth/me" verb=GET {
  api_group = "sistema de vendas"
  auth = "comerciante"

  input {
  }

  stack {
    db.get comerciante {
      field_name = "id"
      field_value = $auth.id
      output = ["id", "nome", "email", "nome_loja"]
    } as $comerciante
  }

  response = $comerciante
  guid = "kvqp1a02fGJV2wdo85ZIVpM1GVU"
}