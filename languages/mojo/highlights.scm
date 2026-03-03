; Identifier naming conventions
(identifier) @variable

(attribute
  attribute: (identifier) @property)

; CamelCase for types/structs
((identifier) @type.class
  (#match? @type.class "^_*[A-Z][A-Za-z0-9_]*$"))

; ALL_CAPS for constants
((identifier) @constant
  (#match? @constant "^_*[A-Z][A-Z0-9_]*$"))

(type
  (identifier) @type)

(comment) @comment

(string) @string

(escape_sequence) @string.escape

; Function calls
(call
  function: (attribute
    attribute: (identifier) @function.method.call))

(call
  function: (identifier) @function.call)

; Decorators
(decorator
  "@" @punctuation.special)

(decorator
  "@" @punctuation.special
  [
    (identifier) @function.decorator
    (attribute
      attribute: (identifier) @function.decorator)
    (call
      function: (identifier) @function.decorator.call)
    (call
      (attribute
        attribute: (identifier) @function.decorator.call))
  ])

; Function and class definitions
(function_definition
  name: (identifier) @function.definition)

; Magic/dunder methods (aligned with VS Code Mojo extension)
(function_definition
  name: (identifier) @function.special.definition
  (#match? @function.special.definition "^__[a-zA-Z][a-zA-Z0-9_]*__$"))

; Function parameters
(function_definition
  parameters: (parameters
    [
      (identifier) @variable.parameter
      (typed_parameter
        (identifier) @variable.parameter)
      (default_parameter
        name: (identifier) @variable.parameter)
      (typed_default_parameter
        name: (identifier) @variable.parameter)
    ]))

; Keyword arguments
(call
  arguments: (argument_list
    (keyword_argument
      name: (identifier) @function.kwargs)))

; Class/struct definitions
(class_definition
  name: (identifier) @type.class.definition)

(class_definition
  superclasses: (argument_list
    (identifier) @type.class.inheritance))

; Literals
[
  (true)
  (false)
] @boolean

[
  (none)
] @constant.builtin

[
  (integer)
  (float)
] @number

; Self references
(self_parameter) @variable.special

((identifier) @variable.special
  (#any-of? @variable.special "self" "Self"))

; Punctuation
[
  "."
  ","
  ":"
] @punctuation.delimiter

[
  "("
  ")"
  "["
  "]"
  "{"
  "}"
] @punctuation.bracket

(interpolation
  "{" @punctuation.special
  "}" @punctuation.special) @embedded

; Docstrings
(module
  .
  (expression_statement
    (string) @string.doc)+)

(class_definition
  body: (block
    .
    (expression_statement
      (string) @string.doc)+))

(function_definition
  "def"
  name: (_)
  (parameters)?
  body: (block
    .
    (expression_statement
      (string) @string.doc)+))

(function_definition
  "fn"
  name: (_)
  (parameters)?
  body: (block
    .
    (expression_statement
      (string) @string.doc)+))

; Operators
[
  "-"
  "-="
  "!="
  "*"
  "**"
  "**="
  "*="
  "/"
  "//"
  "//="
  "/="
  "&"
  "%"
  "%="
  "^"
  "+"
  "->"
  "+="
  "<"
  "<<"
  "<="
  "="
  "=="
  ">"
  ">="
  ">>"
  "|"
  "~"
  "&="
  "<<="
  ">>="
  "^="
  "|="
] @operator

; Keyword operators
[
  "and"
  "in"
  "is"
  "is not"
  "not"
  "not in"
  "or"
] @keyword.operator

; Keywords
[
  "as"
  "assert"
  "async"
  "await"
  "break"
  "capturing"
  "case"
  "continue"
  "del"
  "elif"
  "else"
  "escaping"
  "except"
  "finally"
  "for"
  "from"
  "global"
  "if"
  "import"
  "match"
  "nonlocal"
  "pass"
  "raise"
  "raises"
  "return"
  "try"
  "while"
  "with"
  "yield"
  "var"
  "alias"
  "borrowed"
  "inout"
  "owned"
  "ref"
  "mut"
  "out"
  "read"
  "exec"
  "inferred"
] @keyword

; Definition keywords (highlighted distinctly from regular keywords)
[
  "def"
  "fn"
  "class"
  "struct"
  "trait"
  "lambda"
  "type"
] @keyword.definition

; Builtin types (aligned with official VS Code Mojo extension + Mojo stdlib)
[
  (call
    function: (identifier) @type.builtin)
  (type
    (identifier) @type.builtin)
  (#any-of? @type.builtin
    ; Python builtins (from VS Code extension)
    "bool" "bytearray" "bytes" "classmethod" "complex" "dict"
    "float" "frozenset" "int" "list" "memoryview" "object"
    "property" "set" "slice" "staticmethod" "str" "tuple" "type"
    "super" "range"
    ; Mojo MLIR builtins (from VS Code extension)
    "__mlir_attr" "__mlir_op" "__mlir_type"
    ; Mojo stdlib types
    "Bool" "Int" "Int8" "Int16" "Int32" "Int64"
    "UInt8" "UInt16" "UInt32" "UInt64"
    "Float16" "Float32" "Float64"
    "String" "StringLiteral" "StringRef"
    "DType" "Tensor" "List" "Dict" "Set" "Tuple"
    "SIMD" "DynamicVector" "InlinedFixedVector"
    "Pointer" "AnyType" "NoneType" "Never"
    "UnsafeUnion" "CStringSlice" "EllipsisType")
]

; Builtin functions (aligned with official VS Code Mojo extension)
((call
  function: (identifier) @function.builtin)
  (#any-of? @function.builtin
    ; Python builtins
    "__import__" "abs" "aiter" "all" "any" "anext" "ascii" "bin"
    "bool" "breakpoint" "callable" "chr" "compile" "complex"
    "delattr" "dict" "dir" "divmod" "enumerate" "eval" "exec"
    "exit" "filter" "float" "format" "frozenset" "getattr"
    "globals" "hasattr" "hash" "help" "hex" "id" "input" "int"
    "isinstance" "issubclass" "iter" "len" "list" "locals" "map"
    "max" "memoryview" "min" "next" "object" "oct" "open" "ord"
    "pow" "print" "quit" "range" "repr" "reversed" "round" "set"
    "setattr" "slice" "sorted" "str" "sum" "super" "tuple" "type"
    "vars" "zip"
    ; Mojo-specific builtins
    "rebind" "constrained" "parameter" "autotune"
    "__mlir_attr" "__mlir_op" "__mlir_type"))
