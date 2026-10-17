// tabela do dono da loja
table comerciante {
  auth = true

  schema {
    int id
  
    // nome do comerciante
    text nome? filters=trim
  
    email email? filters=trim|lower
    password senha? {
      sensitive = true
      visibility = "internal"
    }
  
    text nome_loja? filters=trim
  }

  index = [{type: "primary", field: [{name: "id"}]}]
  autocomplete = [{name: "id"}]
  guid = "OF8HbU3jufcDfmrUsV-rvaU27VQ"
}