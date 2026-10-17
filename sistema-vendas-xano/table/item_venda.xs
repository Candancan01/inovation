// Tabela de itens vinculados a uma venda
table item_venda {
  auth = false

  schema {
    // Identificador único do item da venda
    int id
  
    // Referência para a venda
    int id_venda {
      table = "venda"
    }
  
    // Referência para o produto vendido
    int id_produto {
      table = "produto"
    }
  
    // Quantidade do produto vendida
    decimal quantidade
  
    // Preço unitário do produto no momento da venda
    decimal preco_unitario
  
    // Valor total do item (quantidade * preco_unitario)
    decimal subtotal
  }

  index = [
    {type: "primary", field: [{name: "id"}]}
    {type: "btree", field: [{name: "id_venda"}]}
    {type: "btree", field: [{name: "id_produto"}]}
  ]

  guid = "YXr13ck8Y4FMzZURiTBFePuHHdY"
}