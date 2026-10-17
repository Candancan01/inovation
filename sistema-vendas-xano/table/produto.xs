// Tabela de produtos do sistema
table produto {
  auth = false

  schema {
    // Identificador único do produto
    int id
  
    // Referência para a categoria do produto
    int id_categoria {
      table = "categoria"
    }
  
    // Nome do produto
    text nome filters=trim
  
    // Unidade de medida (ex: UN, KG, LT)
    text unidade?
  
    // Preço de custo do produto
    decimal preco_custo?
  
    // Preço de venda do produto
    decimal preco_vendido?
  
    // Quantidade média em estoque
    int estoque_minimo?
  
    // Define se o produto está ativo no sistema
    bool ativo?=true
  
    // Data de validade do produto
    date possui_validade?
  
    text codigo? filters=trim
  }

  index = [
    {type: "primary", field: [{name: "id"}]}
    {type: "btree", field: [{name: "id_categoria"}]}
  ]

  guid = "Rc7xvlQ0l1xWhsKggO7gIJVO0QA"
}