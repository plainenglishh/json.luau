# json.luau

A reasonably fast pure-Luau JSON library.

## Usage

### Example

```luau
local json = require("@json/");

local empty_array = {};
json.set_json_type(empty_array, "array");

local value = {
    null = json.null,
    boolean_true = true,
    boolean_false = false,
    number = -1000,
    string = "Hello, World!",
    raw_buf = buffer.fromstring("i KNOW this doesn't contain invalid chars"),
    array = {1, 2, 3},
    object = { a = 1, b = 2, c = 3 },
    empty_array = empty_array,
    empty_object = json.set_json_type({}, "object"),
};

local encoded = json.encode(value, {
    pretty = 4, 
    raw_buffers = false, -- dont escape `raw_buf`
});

print(buffer.tostring(encoded));
```

#### Output

```json
{
    "number": -1000,
    "string": "Hello, World!",
    "empty_object": {},
    "boolean_false": false,
    "empty_array": [],
    "boolean_true": true,
    "object": {
        "a": 1,
        "c": 3,
        "b": 2
    },
    "array": [
        1,
        2,
        3
    ],
    "null": null,
    "raw_buf": "i KNOW this doesn't contain invalid chars"
}
```

### Raw Buffers

The encoder `raw_buffer` flag can be enabled to skip character escaping and
validation in `buffer` values. This can massively speed up encoding, but passes
the onus onto the caller to ensure buffers don't contain invalid characters.

### Luau/JSON Inconsistencies

Luau and JSON are inconsistent in a few ways:

1. Luau has no concept of `null`, with `nil` representing both `null` and
   `undefined`;
2. Luau does not differentiate between arrays and objects.

To patch these inconsistencies, `json.luau`:

1. provides a `json.null` constant to explicitly mark a value as `null`.
2. checks for a `__jsontype` meta-field to determine what table type to default
   to for any given ambiguous table.
