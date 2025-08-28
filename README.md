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

### Buffers

The encoder can accept `buffer`s, which are treated the same as `string` values
by default.

The encoder `raw_buffer` flag can be enabled to insert buffers as-is, with
surrounding quotes. This can massively speed up encoding, but passes the onus on
the caller to ensure the buffer doesn't contain invalid characters. In
`raw_buffer` mode, the encoder doesn't validate whether the buffer is escaped.

### Luau/JSON Inconsistencies

Luau and JSON are inconsistent in a few ways:

1. Luau has no concept of `null`, with `nil` representing both `null` and
   `undefined`;
2. Luau does not differentiate between arrays and objects.

#### Null

The library provides a `json.null` constant to explicitly mark a value as
`null`.

#### Table Types

The library also provides a mechanism for specifying whether a table is an array
or an object: table types.

When the type of a table is ambiguous, the encoder checks for the `__jsontype`
meta-field to determine what type it should default to.

The library provides `json.get_json_type` and `json.get_json_type` to assist
with this.
