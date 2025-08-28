local net = require("@lune/net");
local serde = require("@lune/serde")
local src = require("@json/");

local function tbl_eq(a: {[any]: any}, b: {[any]: any}): boolean
    if a == b then
        return true;
    end

    if typeof(a) ~= typeof(b) then
        return false;
    end

    if typeof(a) ~= "table" then
        return a == b;
    end

    for k: any, v in a do
        if not tbl_eq(v, b[k]) then
            return false;
        end
    end

    for k: any, v in b do
        if not tbl_eq(v, a[k]) then
            return false;
        end
    end

    return true;
end

local URLS = {
    "https://jsonplaceholder.typicode.com/posts",
    "https://jsonplaceholder.typicode.com/comments",
    "https://jsonplaceholder.typicode.com/albums",
    "https://jsonplaceholder.typicode.com/photos",
    "https://jsonplaceholder.typicode.com/todos",
    "https://jsonplaceholder.typicode.com/users",
    "https://microsoftedge.github.io/Demos/json-dummy-data/64KB.json",
    "https://microsoftedge.github.io/Demos/json-dummy-data/128KB.json",
    "https://microsoftedge.github.io/Demos/json-dummy-data/256KB.json",
    "https://microsoftedge.github.io/Demos/json-dummy-data/512KB.json",
    "https://microsoftedge.github.io/Demos/json-dummy-data/1MB.json",
    "https://microsoftedge.github.io/Demos/json-dummy-data/5MB.json",
    "https://microsoftedge.github.io/Demos/json-dummy-data/64KB-min.json",
    "https://microsoftedge.github.io/Demos/json-dummy-data/128KB-min.json",
    "https://microsoftedge.github.io/Demos/json-dummy-data/256KB-min.json",
    "https://microsoftedge.github.io/Demos/json-dummy-data/512KB-min.json",
    "https://microsoftedge.github.io/Demos/json-dummy-data/1MB-min.json",
    "https://microsoftedge.github.io/Demos/json-dummy-data/5MB-min.json",
};

for _, url in URLS do
    print(`* testing '{url}'`);
    
    local raw_data = net.request(url).body;
    local expected = serde.decode("json", raw_data);
    print(`    * fetched`);

    local decoded = src.decode(raw_data);
    assert(tbl_eq(expected, decoded :: any));
    print(`    * decoded successfully`);

    local encoded = buffer.tostring(src.encode(decoded, {pretty = false}));
    local redecoded = serde.decode("json", encoded);
    assert(tbl_eq(expected, redecoded :: any));
    print(`    * encoded successfully`);

    local encoded_pretty = buffer.tostring(src.encode(decoded, {pretty = true}));
    local redecoded_pretty = serde.decode("json", encoded_pretty);
    assert(tbl_eq(expected, redecoded_pretty :: any));
    print(`    * encoded successfully (pretty)`);
end

return {};