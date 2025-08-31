- Encoding modes (`ascii`, `utf-8`)

- Nicer error handling
- `json.encode` optimisations
  - escaping
    - Escape strings inline

- `json.decode` optimisations:
  - unescaping
    - Read \uXXXX escape codepoints directly from the input buffer rather than
      using readstring & tonumber
    - Write utf8 codepoints directly to `string_buffer` rather than using
      utf.char

- AST Parse API
- JSON Schema
