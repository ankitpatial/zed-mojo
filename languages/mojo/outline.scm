(decorator) @annotation

(class_definition
  "class" @context
  name: (identifier) @name) @item

(class_definition
  "struct" @context
  name: (identifier) @name) @item

(trait_definition
  "trait" @context
  name: (identifier) @name) @item

(function_definition
  "def" @context
  name: (_) @name) @item

(function_definition
  "fn" @context
  name: (_) @name) @item
