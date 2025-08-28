local process = require("@lune/process");
local stdio = require("@lune/stdio");

local ok, err: string = pcall(function()
    print("----- basic.luau");
    require("@self/basic");
    print("----- escapes.luau");
    require("@self/escapes");
    return nil :: any;
end);

if not ok then
    stdio.ewrite(err);
    process.exit(1);
else
    process.exit(1);
end
