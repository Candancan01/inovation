// Tabela de promoções de produtos
table promocao {
  auth = false

  schema {
    // Identificador único da promoção
    int id
  
    // Referência para o produto em promoção
    int id_produto {
      table = "produto"
    }
  
    // Percentual de desconto aplicado (ex: 10.5 para 10.5%)
    decimal percentual_desconto?
  
    // Preço final após o desconto
    decimal preco_promocional?
  
    // Data de início da promoção
    timestamp data_inicio?
  
    // Data de término da promoção
    timestamp data_fim?
  
    // Motivo ou nome da campanha promocional
    text motivo? filters=trim
  
    // Status da promoção (ex: Ativa, Encerrada)
    text status? filters=trim
  }

  index = [
    {type: "primary", field: [{name: "id"}]}
    {type: "btree", field: [{name: "id_produto"}]}
  ]

  guid = "3I-DkCOdcq0kg6ssfaLjaBTdSJc"
}