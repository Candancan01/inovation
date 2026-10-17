// Tabela de movimentações de estoque
table estoque {
  auth = false

  schema {
    // Identificador único da movimentação
    int id
  
    // Referência para o lote de origem
    int id_lote {
      table = "lote"
    }
  
    // Tipo de movimentação (ex: entrada, saída, ajuste)
    text tipo filters=trim
  
    // Quantidade movimentada
    decimal quantidade
  
    // Motivo ou descrição da movimentação
    text motivo?
  }

  index = [
    {type: "primary", field: [{name: "id"}]}
    {type: "btree", field: [{name: "id_lote"}]}
  ]

  guid = "2e3zttLnSbIIzJfC3NaTcDkgQAk"
}