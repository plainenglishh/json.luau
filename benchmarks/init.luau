local serde = require("@lune/serde");
local net = require("@lune/net");

local json = require("@json/");

local lute = require("@self/comparisons/lute");
local jsonlua = require("@self/comparisons/json") :: any;
local jfjson = require("@self/comparisons/jfjson") :: any;
local dkjson = require("@self/comparisons/dkjson") :: any;

local ITERATIONS = 5;

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

local function time<A...>(fn: (A...) -> (), ...: A...): number
    local avg = 0;
    for i = 1, ITERATIONS do
        local start = os.clock();
        fn(...);
        local stop = os.clock();
        avg += stop - start;
    end
    return avg / ITERATIONS;
end

local function speed_difference(base: number, b: number): string
    if base > b then
        return `{math.round((base / b) * 100) / 100}x faster`;
    elseif base < b then
        return `{math.round((b / base) * 100) / 100}x slower`;
    else
        return "same speed";
    end
end

local function bench<A...>(name: string, fns: {[string]: (A...) -> ()}, ...: A...)
    print(`benchmark: {name}:`);
    
    local times = {};
    local max_name_size = 0;
    local max_time_size = 0;
    local a_time = 0;

    for name, fn in fns do
        if #name > max_name_size then 
            max_name_size = #name;
        end

        local ok, t = pcall(time, fn, ...);
        if not ok then
            print(t);
            error("")
        end
        local display_time = math.round(t * 1000 * 1000);
        if #tostring(display_time) > max_time_size then 
            max_time_size = #tostring(display_time);
        end

        local bench = {
            name = name,
            time = t,
        };

        if name == "json.luau" then
            a_time = t;
            table.insert(times, 1, bench);
        else
            table.insert(times, bench);
        end
    end
    
    for _, bench in times do
        print((string.format :: any)(
            `|   %-{max_name_size + 2}s%{max_time_size}ius%s`, 
            bench.name..":",
            bench.time * 1000 * 1000,
            if bench.name == "json.luau" then " (this library)" else " ("..speed_difference(a_time, bench.time)..")"
        ));
    end
end

for _, url in URLS do
    local file = net.request(url).body or error("no body");
    bench(`decode {url}`, {
        ["json.luau"] = function(file)
            json.decode(file);
        end,
        --[[["lune"] = function(file)
            serde.decode("json", file);
        end,]]
        ["lute"] = function(file)
            lute.deserialize(file);
        end,
        ["json.lua"] = function(file)
            jsonlua.decode(file);
        end,
        ["jfjson"] = function(file: any)
            jfjson:decode(file);
        end,
        ["dkjson"] = function(file: any)
            dkjson.decode(file);
        end,
    }, file);
    print("");

    bench(`encode '{url}'`, {
        ["json.luau"] = function(file)
            json.encode(file);
        end,
        --[[["lune"] = function(file)
            serde.encode("json", file);
        end,]]
        ["lute"] = function(file)
            lute.serialize(file);
        end,
        ["json.lua"] = function(file)
            jsonlua.encode(file);
        end,
        ["jfjson"] = function(file: any)
            jfjson:encode(file)
        end,
        ["dkjson"] = function(file: any)
            dkjson.encode(file);
        end,
    }, serde.decode("json", file));
    print("");
end
