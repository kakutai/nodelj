
local ffi = require 'ffi'

--- main options
local aspect = require("aspect.template").new({
    -- debug       = true,
    -- cache       = false,
})

local tmpl = require 'scripts/template'

----------------------------------------------------------------------------------------------

local function init( www_paths )

    tmpl.root = www_paths.global_path
    tmpl.www_dir = www_paths.www_dir
    tmpl.site_args = www_paths.site_args or {}

    aspect.loader = require("aspect.loader.filesystem").new( tmpl.root )
end 

----------------------------------------------------------------------------------------------

local function readfile( fname )

    local fh = io.open( tmpl.root..'/'..fname, "rb" )
    local dsize = 0

    local data = ""
    if(fh) then 
        local fstart = fh:seek("cur")
        fh:seek("end")
        dsize = fh:seek("cur") - fstart
        fh:seek("set", 0)

        data = fh:read("*a")
        -- dsize = #data
        fh:close()
    else
        print("Error loading file: ",  tmpl.root..'/'..fname)
        assert(true)
    end
    return data, dsize
end

----------------------------------------------------------------------------------------------

local function parse( fname )

    local fullpath = fname
    -- p("Site args: ", tmpl.site_args)
    local output, err = aspect:render(fullpath, tmpl.site_args)
    local outputstr = tostring(output)

    if(err) then
        local errfile = io.open("aspect-error.log", "w")
        errfile:write( tostring(err) )
        errfile:close()
    end
    return outputstr, #outputstr
end

-----------------------------------------------------------------------------------------------

return {

    init = init,
    parse = parse,
    readfile = readfile,
    root = tmpl.root,
}