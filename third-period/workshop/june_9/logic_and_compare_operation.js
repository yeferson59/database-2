// use help_mongo

db.help.insertMany([
  {
    name: "eq",
    description: "Compara si un valor es igual a otro.",
    mean: "El campo1 es igual a 5.",
    sintax: "{ campo1: { $eq: 5 } }",
    type: "comparacion",
    sentencess: [
      "db.help.find({ type: 'comparacion', name: 'eq' })",
      "db.help.findOne({ name: 'eq' })",
      "db.help.find({ name: 'eq' })",
    ],
  },
  {
    name: "ne",
    description: "Compara si un valor NO es igual a otro.",
    mean: "El campo1 es diferente de 5.",
    sintax: "{ campo1: { $ne: 5 } }",
    type: "comparacion",
    sentences: [
      "db.help.find({ type: 'comparacion', name: 'ne' })",
      "db.help.findOne({ name: 'ne' })",
      "db.help.find({ name: 'ne' })",
    ],
  },
  {
    name: "gt",
    description: "Compara si un valor es mayor que otro.",
    mean: "El campo1 es mayor que 10.",
    sintax: "{ campo1: { $gt: 10 } }",
    type: "comparacion",
    sentences: [
      "db.help.find({ type: 'comparacion', name: 'gt' })",
      "db.help.findOne({ name: 'gt' })",
      "db.help.find({ name: 'gt' })",
    ],
  },
  {
    name: "gte",
    description: "Compara si un valor es mayor o igual que otro.",
    mean: "El campo1 es mayor o igual a 10.",
    sintax: "{ campo1: { $gte: 10 } }",
    type: "comparacion",
    sentences: [
      "db.help.find({ type: 'comparacion', name: 'gte' })",
      "db.help.findOne({ name: 'gte' })",
      "db.help.find({ name: 'gte' })",
    ],
  },
  {
    name: "lt",
    description: "Compara si un valor es menor que otro.",
    mean: "El campo1 es menor que 10.",
    sintax: "{ campo1: { $lt: 10 } }",
    type: "comparacion",
    sentences: [
      "db.help.find({ type: 'comparacion', name: 'lt' })",
      "db.help.findOne({ name: 'lt' })",
      "db.help.find({ name: 'lt' })",
    ],
  },
  {
    name: "lte",
    description: "Compara si un valor es menor o igual que otro.",
    mean: "El campo1 es menor o igual a 10.",
    sintax: "{ campo1: { $lte: 10 } }",
    type: "comparacion",
    sentences: [
      "db.help.find({ type: 'comparacion', name: 'lte' })",
      "db.help.findOne({ name: 'lte' })",
      "db.help.find({ name: 'lte' })",
    ],
  },
  {
    name: "in",
    description: "Verifica si un campo está dentro de un conjunto de valores.",
    mean: "El campo1 es igual a uno de los valores del arreglo [1, 2, 3].",
    sintax: "{ campo1: { $in: [1, 2, 3] } }",
    type: "comparacion",
    sentences: [
      "db.help.find({ type: 'comparacion', name: 'in' })",
      "db.help.findOne({ name: 'in' })",
      "db.help.find({ name: 'in' })",
    ],
  },
  {
    name: "nin",
    description:
      "Verifica si un campo NO está dentro de un conjunto de valores.",
    mean: "El campo1 no es igual a ninguno de los valores del arreglo [1, 2, 3].",
    sintax: "{ campo1: { $nin: [1, 2, 3] } }",
    type: "comparacion",
    sentences: [
      "db.help.find({ type: 'comparacion', name: 'nin' })",
      "db.help.findOne({ name: 'nin' })",
      "db.help.find({ name: 'nin' })",
    ],
  },
  {
    name: "exists",
    description: "Verifica si un campo existe o no en los documentos.",
    mean: "El campo1 existe en el documento.",
    sintax: "{ campo1: { $exists: true } }",
    type: "comparacion",
    sentences: [
      "db.help.find({ type: 'comparacion', name: 'exists' })",
      "db.help.findOne({ name: 'exists' })",
      "db.help.find({ name: 'exists' })",
    ],
  },
  {
    name: "type",
    description: "Verifica el tipo de dato de un campo.",
    mean: "El campo1 es de tipo string.",
    sintax: '{ campo1: { $type: "string" } }',
    type: "comparacion",
    sentences: [
      "db.help.find({ type: 'comparacion', name: 'type' })",
      "db.help.findOne({ name: 'type' })",
      "db.help.find({ name: 'type' })",
    ],
  },
  {
    name: "and",
    description: "Ambas condiciones deben cumplirse.",
    mean: "El campo1 es mayor que 5 y el campo2 menor que 20.",
    sintax: "{ $and: [ { campo1: { $gt: 5 } }, { campo2: { $lt: 20 } } ] }",
    type: "logico",
    sentences: [
      "db.help.find({ type: 'logico', name: 'and' })",
      "db.help.findOne({ name: 'and' })",
      "db.help.find({ name: 'and' })",
    ],
  },
  {
    name: "or",
    description: "Al menos una condición debe cumplirse.",
    mean: "El campo1 es mayor que 5 o el campo2 menor que 20.",
    sintax: "{ $or: [ { campo1: { $gt: 5 } }, { campo2: { $lt: 20 } } ] }",
    type: "logico",
    sentences: [
      "db.help.find({ type: 'logico', name: 'or' })",
      "db.help.findOne({ name: 'or' })",
      "db.help.find({ name: 'or' })",
    ],
  },
  {
    name: "not_simple",
    description: "Niega una condición simple.",
    mean: "El campo1 NO es mayor que 10.",
    sintax: "{ campo1: { $not: { $gt: 10 } } }",
    type: "logico",
    sentences: [
      "db.help.find({ type: 'logico', name: 'not_simple' })",
      "db.help.findOne({ name: 'not_simple' })",
      "db.help.find({ name: 'not_simple' })",
    ],
  },
  {
    name: "nor",
    description: "Ninguna de las condiciones debe cumplirse.",
    mean: "Ni el campo1 es igual a 5 ni el campo2 es menor que 3.",
    sintax: "{ $nor: [ { campo1: { $eq: 5 } }, { campo2: { $lt: 3 } } ] }",
    type: "logico",
    sentences: [
      "db.help.find({ type: 'logico', name: 'nor' })",
      "db.help.findOne({ name: 'nor' })",
      "db.help.find({ name: 'nor' })",
    ],
  },
  {
    name: "expr_eq",
    description: "Compara si dos campos son iguales usando $expr.",
    mean: "El valor del campo1 es igual al del campo2.",
    sintax: '{ $expr: { $eq: ["$campo1", "$campo2"] } }',
    type: "expr",
    sentences: [
      "db.help.find({ type: 'expr', name: 'expr_eq' })",
      "db.help.findOne({ name: 'expr_eq' })",
      "db.help.find({ name: 'expr_eq' })",
    ],
  },
  {
    name: "expr_gt",
    description: "Compara si un campo es mayor que otro usando $expr.",
    mean: "El campo1 es mayor que el campo2.",
    sintax: '{ $expr: { $gt: ["$campo1", "$campo2"] } }',
    type: "expr",
    sentences: [
      "db.help.find({ type: 'expr', name: 'expr_gt' })",
      "db.help.findOne({ name: 'expr_gt' })",
      "db.help.find({ name: 'expr_gt' })",
    ],
  },
  {
    name: "not_expr",
    description: "Niega una comparación entre campos usando $expr.",
    mean: "El campo2 NO es mayor que campo3.",
    sintax: '{ campo1: { $not: { $expr: { $gt: ["$campo2", "$campo3"] } } } }',
    type: "expr",
    sentences: [
      "db.help.find({ type: 'expr', name: 'not_expr' })",
      "db.help.findOne({ name: 'not_expr' })",
      "db.help.find({ name: 'not_expr' })",
    ],
  },
  {
    name: "where_simple",
    description: "Evalúa una condición con lógica JavaScript.",
    mean: "La suma de campo1 y campo2 es mayor que 100.",
    sintax: '{ $where: "this.campo1 + this.campo2 > 100" }',
    type: "where",
    sentences: [
      "db.help.find({ type: 'where', name: 'where_simple' })",
      "db.help.findOne({ name: 'where_simple' })",
      "db.help.find({ name: 'where_simple' })",
    ],
  },
  {
    name: "not_where",
    description: "Niega una condición expresada en JavaScript.",
    mean: "El campo1 NO es menor que 10.",
    sintax: '{ campo1: { $not: { $where: "this.campo1 < 10" } } }',
    type: "where",
    sentences: [
      "db.help.find({ type: 'where', name: 'not_where' })",
      "db.help.findOne({ name: 'not_where' })",
      "db.help.find({ name: 'not_where' })",
    ],
  },
  {
    name: "nor_where",
    description:
      "Ninguna condición debe cumplirse, incluyendo lógica JavaScript.",
    mean: "Ni campo1 es igual a valor1 ni campo2 es 'inactivo'.",
    sintax:
      "{ $nor: [ { campo1: valor1 }, { $where: \"this.campo2 == 'inactivo'\" } ] }",
    type: "where",
    sentences: [
      "db.help.find({ type: 'where', name: 'nor_where' })",
      "db.help.findOne({ name: 'nor_where' })",
      "db.help.find({ name: 'nor_where' })",
    ],
  },
  {
    name: "expr_where",
    description:
      "Combina lógica de comparación entre campos con lógica personalizada.",
    mean: "El campo1 es mayor o igual que campo2 Y campo3 es mayor que 10.",
    sintax:
      '{ $and: [ { $expr: { $gte: ["$campo1", "$campo2"] } }, { $where: "this.campo3 > 10" } ] }',
    type: "mixto",
    sentences: [
      "db.help.find({ type: 'mixto', name: 'expr_where' })",
      "db.help.findOne({ name: 'expr_where' })",
      "db.help.find({ name: 'expr_where' })",
    ],
  },
  {
    name: "and_where",
    description: "Combina condiciones estándar con lógica JavaScript.",
    mean: "El campo1 es igual a valor1 y campo2 es menor que 100.",
    sintax: '{ $and: [ { campo1: valor1 }, { $where: "this.campo2 < 100" } ] }',
    type: "mixto",
    sentences: [
      "db.help.find({ type: 'mixto', name: 'and_where' })",
      "db.help.findOne({ name: 'and_where' })",
      "db.help.find({ name: 'and_where' })",
    ],
  },
  {
    name: "and_expr_where",
    description: "Combina $expr con lógica JavaScript.",
    mean: "Campo1 es menor o igual que campo2 Y campo3 no es nulo.",
    sintax:
      '{ $and: [ { $expr: { $lte: ["$campo1", "$campo2"] } }, { $where: "this.campo3 != null" } ] }',
    type: "mixto",
    sentences: [
      "db.help.find({ type: 'mixto', name: 'and_expr_where' })",
      "db.help.findOne({ name: 'and_expr_where' })",
      "db.help.find({ name: 'and_expr_where' })",
    ],
  },
]);

// consultas por tipos de operadores

db.help.find({ type: "comparacion" }).pretty();
db.help.find({ type: "logico" }).pretty();
db.help.find({ type: "expr" }).pretty();
db.help.find({ type: "where" }).pretty();
db.help.find({ type: "mixto" }).pretty();

// Consultas para obtener cada operador lógico individualmente

// $eq
db.help.find({ name: "eq" }).pretty();

// $ne
db.help.find({ name: "ne" }).pretty();

// $gt
db.help.find({ name: "gt" }).pretty();

// $gte
db.help.find({ name: "gte" }).pretty();

// $lt
db.help.find({ name: "lt" }).pretty();

// $lte
db.help.find({ name: "lte" }).pretty();

// $in
db.help.find({ name: "in" }).pretty();

// $nin
db.help.find({ name: "nin" }).pretty();

// $exists
db.help.find({ name: "exists" }).pretty();

// $type
db.help.find({ name: "type" }).pretty();

// $and
db.help.find({ name: "and" }).pretty();

// $or
db.help.find({ name: "or" }).pretty();

// $not (condición simple)
db.help.find({ name: "not_simple" }).pretty();

// $nor
db.help.find({ name: "nor" }).pretty();

// $expr con $eq
db.help.find({ name: "expr_eq" }).pretty();

// $expr con $gt
db.help.find({ name: "expr_gt" }).pretty();

// $not con $expr
db.help.find({ name: "not_expr" }).pretty();

// $where con condición simple
db.help.find({ name: "where_simple" }).pretty();

// $not con $where
db.help.find({ name: "not_where" }).pretty();

// $nor con $where
db.help.find({ name: "nor_where" }).pretty();

// $expr combinado con $where
db.help.find({ name: "expr_where" }).pretty();

// $and combinado con $where
db.help.find({ name: "and_where" }).pretty();

// $and combinado con $expr y $where
db.help.find({ name: "and_expr_where" }).pretty();

// Consultas para obtener todos los operadores lógicos y de comparación
// Estos son los operadores lógicos y de comparación que hemos insertado en la colección "help".
// Puedes ejecutar las siguientes consultas para ver todos los operadores lógicos y de comparación:
db.help
  .find({ type: { $in: ["comparacion", "logico", "expr", "where", "mixto"] } })
  .pretty();
