// Tabela de categorias de produtos
table categoria {
  auth = false

  schema {
    // Identificador único da categoria
    int id
  
    // Nome da categoria
    text nome filters=trim
  
    // Descrição detalhada da categoria
    text descricao?
  
    // Define se a categoria está ativa no sistema
    bool ativo?=true
  }

  index = [{type: "primary", field: [{name: "id"}]}]
  guid = "aO7ODnDk0PfejIG0kNQb8dLeGj0"
}