local json = require("@json/");
local serde = require("@lune/serde");

local ESCAPE_SEQUENCES = {
    "\"\\\\\\/\b\t\n\f\r", -- Basic escapes
    "\u{FFFF}\u{0000}", -- Simple Unicode Escapes
    "\u{1D11E}", -- Long Unicode Escapes
};

for _, escape_sequence in ESCAPE_SEQUENCES do
    local expected = serde.encode("json", escape_sequence);
    print(`* testing {expected}`);

    local encoded = buffer.tostring(json.encode(escape_sequence));
    assert(encoded == expected);
    print(`    * encoded successfully`);

    local decoded = json.decode(encoded);
    assert(decoded == escape_sequence);
    print(`    * decoded successfully`);
end

return {};