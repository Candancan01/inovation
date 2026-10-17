// Tabela de registros de vendas
table venda {
  auth = false

  schema {
    // Identificador único da venda
    int id
  
    // Data em que a venda foi realizada
    date data_venda?
  
    // Valor total da venda
    decimal valor_total
  
    // Forma de pagamento utilizada (ex: Dinheiro, PIX, Cartão)
    text forma_pagamento? filters=trim
  
    // Status atual da venda (ex: Concluída, Cancelada, Pendente)
    text status? filters=trim
  }

  index = [
    {type: "primary", field: [{name: "id"}]}
    {type: "btree", field: [{name: "data_venda", op: "asc"}]}
  ]

  guid = "_zOnzt32VbZHAg4i6tT8anWjhGw"
}