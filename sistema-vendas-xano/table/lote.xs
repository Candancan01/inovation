// Tabela de lotes de produtos recebidos
table lote {
  auth = false

  schema {
    // Identificador único do lote
    int id
  
    // Referência para o produto
    int id_produto {
      table = "produto"
    }
  
    // Quantidade total que chegou neste lote
    decimal quantidade_chegada
  
    // Data em que o lote deu entrada no sistema
    date data_entrada?
  }

  index = [
    {type: "primary", field: [{name: "id"}]}
    {type: "btree", field: [{name: "id_produto"}]}
  ]

  guid = "xFgcFCU4pxyXl8M2ednJQPQieCY"
}