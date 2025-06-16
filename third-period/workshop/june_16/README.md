# Guía Completa: Documentos Anidados en MongoDB

## 1. Cómo insertar documentos anidados

### Conceptos básicos
Los documentos anidados en MongoDB permiten almacenar estructuras de datos complejas dentro de un solo documento, como objetos y arrays de objetos.

### Sintaxis básica para insertar documentos anidados

```javascript
// Insertar un documento con objetos anidados
db.usuarios.insertOne({
  nombre: "Juan Pérez",
  edad: 30,
  direccion: {
    calle: "Av. Principal 123",
    ciudad: "Bogotá",
    codigo_postal: "110111",
    pais: "Colombia"
  },
  contactos: [
    {
      tipo: "email",
      valor: "juan@email.com"
    },
    {
      tipo: "telefono",
      valor: "+57 300 123 4567"
    }
  ]
});

// Insertar múltiples documentos con estructuras anidadas
db.productos.insertMany([
  {
    nombre: "Laptop",
    precio: 1500000,
    especificaciones: {
      procesador: "Intel i7",
      ram: "16GB",
      almacenamiento: "512GB SSD"
    },
    categorias: ["electrónicos", "computadoras"],
    reviews: [
      {
        usuario: "cliente1",
        calificacion: 5,
        comentario: "Excelente producto"
      }
    ]
  },
  {
    nombre: "Smartphone",
    precio: 800000,
    especificaciones: {
      procesador: "Snapdragon 888",
      ram: "8GB",
      almacenamiento: "256GB"
    },
    categorias: ["electrónicos", "móviles"]
  }
]);
```

## 2. Cómo traer datos de documentos anidados

### Consultar campos anidados usando dot notation

```javascript
// Buscar por campo anidado específico
db.usuarios.find({"direccion.ciudad": "Bogotá"});

// Buscar por múltiples campos anidados
db.usuarios.find({
  "direccion.ciudad": "Bogotá",
  "direccion.pais": "Colombia"
});

// Buscar en arrays de objetos
db.usuarios.find({"contactos.tipo": "email"});

// Buscar usando proyección para mostrar solo campos específicos
db.usuarios.find(
  {"direccion.ciudad": "Bogotá"},
  {
    nombre: 1,
    "direccion.ciudad": 1,
    "contactos.valor": 1
  }
);
```

### Usar operadores para consultas complejas

```javascript
// Usar $elemMatch para arrays de objetos
db.productos.find({
  reviews: {
    $elemMatch: {
      calificacion: {$gte: 4},
      usuario: "cliente1"
    }
  }
});

// Usar $exists para verificar existencia de campos anidados
db.usuarios.find({"direccion.codigo_postal": {$exists: true}});

// Usar $in para buscar en arrays
db.productos.find({categorias: {$in: ["electrónicos"]}});
```

## 3. Cómo listar documentos

### Comandos básicos de listado

```javascript
// Listar todos los documentos
db.usuarios.find();

// Listar con formato legible
db.usuarios.find().pretty();

// Listar primeros N documentos
db.usuarios.find().limit(5);

// Listar con paginación
db.usuarios.find().skip(10).limit(5);

// Listar ordenado por campo anidado
db.usuarios.find().sort({"direccion.ciudad": 1});

// Contar documentos
db.usuarios.countDocuments();
db.usuarios.countDocuments({"direccion.ciudad": "Bogotá"});
```

### Proyecciones avanzadas

```javascript
// Incluir solo campos específicos
db.usuarios.find({}, {
  nombre: 1,
  "direccion.ciudad": 1,
  "contactos.valor": 1
});

// Excluir campos específicos
db.usuarios.find({}, {
  "direccion.codigo_postal": 0,
  contactos: 0
});

// Usar $slice para limitar elementos en arrays
db.productos.find({}, {
  nombre: 1,
  reviews: {$slice: 2} // Solo los primeros 2 reviews
});
```

## 4. Cómo actualizar documentos anidados

### Actualizar campos anidados específicos

```javascript
// Actualizar un campo anidado
db.usuarios.updateOne(
  {nombre: "Juan Pérez"},
  {$set: {"direccion.ciudad": "Medellín"}}
);

// Actualizar múltiples campos anidados
db.usuarios.updateOne(
  {nombre: "Juan Pérez"},
  {
    $set: {
      "direccion.ciudad": "Cali",
      "direccion.codigo_postal": "760001"
    }
  }
);

// Agregar elemento a un array
db.usuarios.updateOne(
  {nombre: "Juan Pérez"},
  {
    $push: {
      contactos: {
        tipo: "linkedin",
        valor: "juan-perez-linkedin"
      }
    }
  }
);
```

### Operadores avanzados de actualización

```javascript
// Actualizar elemento específico en array usando $
db.productos.updateOne(
  {"reviews.usuario": "cliente1"},
  {$set: {"reviews.$.calificacion": 4}}
);

// Actualizar múltiples elementos en array usando $[]
db.productos.updateMany(
  {},
  {$set: {"reviews.$[].fecha": new Date()}}
);

// Actualizar con filtros usando $[<identifier>]
db.productos.updateMany(
  {},
  {$set: {"reviews.$[elem].verificado": true}},
  {arrayFilters: [{"elem.calificacion": {$gte: 4}}]}
);

// Usar $addToSet para evitar duplicados
db.productos.updateOne(
  {nombre: "Laptop"},
  {$addToSet: {categorias: "gaming"}}
);

// Remover elementos de arrays
db.usuarios.updateOne(
  {nombre: "Juan Pérez"},
  {$pull: {contactos: {tipo: "telefono"}}}
);
```

## 5. Cómo consultar un documento anidado

### Consultas específicas y complejas

```javascript
// Buscar documento exacto anidado
db.usuarios.find({
  direccion: {
    calle: "Av. Principal 123",
    ciudad: "Bogotá",
    codigo_postal: "110111",
    pais: "Colombia"
  }
});

// Consultar con expresiones regulares
db.usuarios.find({"direccion.calle": /^Av\./});

// Usar agregaciones para consultas complejas
db.usuarios.aggregate([
  {$match: {"direccion.ciudad": "Bogotá"}},
  {$project: {
    nombre: 1,
    ciudad: "$direccion.ciudad",
    num_contactos: {$size: "$contactos"}
  }}
]);

// Desenrollar arrays para consultas
db.productos.aggregate([
  {$unwind: "$reviews"},
  {$match: {"reviews.calificacion": {$gte: 4}}},
  {$group: {
    _id: "$nombre",
    promedio_calificacion: {$avg: "$reviews.calificacion"}
  }}
]);
```

## 6. Documentos anidados - Mejores prácticas

### Cuándo usar documentos anidados vs referencias

**Usar documentos anidados cuando:**
- Los datos están estrechamente relacionados
- Se consultan frecuentemente juntos
- El tamaño del documento no excede 16MB
- Los datos anidados no crecen indefinidamente

**Usar referencias cuando:**
- Los datos pueden crecer sin límite
- Se necesita consultar los datos por separado frecuentemente
- Múltiples documentos referencian los mismos datos

### Estructura recomendada

```javascript
// ✅ Buena estructura - datos relacionados y de tamaño limitado
{
  _id: ObjectId("..."),
  usuario: "juan123",
  perfil: {
    nombre: "Juan Pérez",
    edad: 30,
    ubicacion: {
      ciudad: "Bogotá",
      pais: "Colombia"
    }
  },
  configuraciones: {
    tema: "oscuro",
    notificaciones: true,
    idioma: "es"
  }
}

// ❌ Evitar - arrays que pueden crecer indefinidamente
{
  _id: ObjectId("..."),
  usuario: "juan123",
  posts: [ /* miles de posts */ ]
}
```

## 7. Cómo buscar en documentos anidados

### Técnicas avanzadas de búsqueda

```javascript
// Búsqueda con múltiples condiciones
db.usuarios.find({
  $and: [
    {"direccion.ciudad": "Bogotá"},
    {"contactos.tipo": "email"},
    {edad: {$gte: 25}}
  ]
});

// Búsqueda con operadores lógicos
db.productos.find({
  $or: [
    {"especificaciones.ram": "16GB"},
    {"especificaciones.procesador": /Intel/}
  ]
});

// Búsqueda de texto en campos anidados
db.productos.find({
  $text: {$search: "laptop gaming"}
});

// Búsqueda geoespacial en documentos anidados
db.usuarios.find({
  "direccion.coordenadas": {
    $near: {
      $geometry: {type: "Point", coordinates: [-74.0, 4.6]},
      $maxDistance: 1000
    }
  }
});
```

## 8. Proyección de atributos en documentos anidados

### Técnicas de proyección avanzadas

```javascript
// Proyección con $elemMatch
db.productos.find(
  {},
  {
    nombre: 1,
    reviews: {
      $elemMatch: {calificacion: {$gte: 4}}
    }
  }
);

// Proyección con $slice para arrays
db.productos.find(
  {},
  {
    nombre: 1,
    reviews: {$slice: -3} // Últimos 3 reviews
  }
);

// Proyección con operadores de agregación
db.usuarios.aggregate([
  {
    $project: {
      nombre: 1,
      ciudad: "$direccion.ciudad",
      email_principal: {
        $arrayElemAt: [
          {
            $filter: {
              input: "$contactos",
              cond: {$eq: ["$$this.tipo", "email"]}
            }
          },
          0
        ]
      }
    }
  }
]);
```

## Ejemplo práctico: Sistema de especies Pokémon

```javascript
// Crear documento anidado de especie Pokémon
db.pokemon.insertOne({
  numero: 25,
  nombre: "Pikachu",
  tipos: ["Eléctrico"],
  estadisticas: {
    hp: 35,
    ataque: 55,
    defensa: 40,
    velocidad: 90
  },
  habilidades: [
    {
      nombre: "Electricidad Estática",
      descripcion: "Puede paralizar al contacto",
      oculta: false
    },
    {
      nombre: "Pararrayos",
      descripcion: "Atrae ataques eléctricos",
      oculta: true
    }
  ],
  evoluciones: [
    {
      nombre: "Raichu",
      nivel: null,
      metodo: "Piedra Trueno"
    }
  ],
  ubicaciones: [
    {
      region: "Kanto",
      lugares: ["Bosque Verde", "Ruta 2"]
    }
  ]
});

// Consultas específicas para Pokémon
// Buscar Pokémon por tipo
db.pokemon.find({tipos: "Eléctrico"});

// Buscar por estadística específica
db.pokemon.find({"estadisticas.velocidad": {$gte: 80}});

// Buscar por habilidad oculta
db.pokemon.find({"habilidades.oculta": true});

// Actualizar estadística
db.pokemon.updateOne(
  {nombre: "Pikachu"},
  {$inc: {"estadisticas.hp": 5}}
);

// Agregar nueva ubicación
db.pokemon.updateOne(
  {nombre: "Pikachu"},
  {
    $push: {
      "ubicaciones.0.lugares": "Ciudad Celeste"
    }
  }
);
```

## Consideraciones de rendimiento

### Índices en campos anidados

```javascript
// Crear índices para campos anidados
db.usuarios.createIndex({"direccion.ciudad": 1});
db.productos.createIndex({"especificaciones.procesador": 1});

// Índice compuesto con campos anidados
db.usuarios.createIndex({
  "direccion.ciudad": 1,
  "direccion.pais": 1
});

// Índice en arrays
db.productos.createIndex({"reviews.calificacion": 1});
```

### Límites y consideraciones
- Tamaño máximo de documento: 16MB
- Máximo 100 niveles de anidación
- Los arrays grandes pueden afectar el rendimiento
- Usar proyecciones para reducir la transferencia de datos

## Conclusiones

Los documentos anidados en MongoDB ofrecen flexibilidad para modelar datos complejos, pero requieren un diseño cuidadoso para optimizar el rendimiento y mantener la escalabilidad. La clave está en encontrar el equilibrio entre la desnormalización (documentos anidados) y la normalización (referencias) según las necesidades específicas de cada aplicación.

---

## 9. Eliminación de documentos y subdocumentos anidados

### Eliminar documentos completos

```javascript
// Eliminar un documento completo
db.usuarios.deleteOne({nombre: "Juan Pérez"});

// Eliminar varios documentos por condición
db.productos.deleteMany({"especificaciones.ram": "8GB"});
```

### Eliminar elementos específicos de arrays anidados

```javascript
// Eliminar un elemento específico de un array anidado
db.usuarios.updateOne(
  {nombre: "Juan Pérez"},
  {$pull: {contactos: {tipo: "email"}}}
);

// Eliminar todos los elementos de un array que cumplan una condición
db.productos.updateMany(
  {},
  {$pull: {reviews: {calificacion: {$lt: 3}}}}
);
```

---

## 10. Validación de esquemas para documentos anidados

Puedes definir reglas de validación para asegurar la estructura de los documentos y subdocumentos.

```javascript
db.createCollection("usuarios", {
  validator: {
    $jsonSchema: {
      bsonType: "object",
      required: ["nombre", "direccion"],
      properties: {
        nombre: {bsonType: "string"},
        direccion: {
          bsonType: "object",
          required: ["ciudad", "pais"],
          properties: {
            ciudad: {bsonType: "string"},
            pais: {bsonType: "string"}
          }
        }
      }
    }
  }
});
```

---

## 11. Actualizaciones condicionales y upserts en documentos anidados

Puedes actualizar un documento si existe o insertarlo si no existe (upsert), incluso con campos anidados.

```javascript
// Upsert con campo anidado
db.usuarios.updateOne(
  {nombre: "Ana Gómez"},
  {
    $set: {
      "direccion.ciudad": "Cartagena",
      "direccion.pais": "Colombia"
    }
  },
  {upsert: true}
);
```

---

## 12. Manejo de arrays de subdocumentos únicos

Evita duplicados en arrays de subdocumentos usando `$addToSet`.

```javascript
// Agregar solo si no existe un subdocumento igual
db.usuarios.updateOne(
  {nombre: "Juan Pérez"},
  {
    $addToSet: {
      contactos: {
        tipo: "email",
        valor: "nuevo@email.com"
      }
    }
  }
);
```

---

## 13. Ejemplo de agregación con $lookup (referencias y anidados)

Puedes combinar documentos anidados y referencias usando `$lookup` para unir colecciones.

```javascript
db.ordenes.aggregate([
  {
    $lookup: {
      from: "usuarios",
      localField: "usuario_id",
      foreignField: "_id",
      as: "usuario_info"
    }
  },
  {
    $unwind: "$usuario_info"
  },
  {
    $project: {
      numero_orden: 1,
      "usuario_info.nombre": 1,
      "usuario_info.direccion.ciudad": 1
    }
  }
]);
```
