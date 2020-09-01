local ffi = require 'ffi'
local dbg = require 'scripts.debugger'

local twig = require 'scripts/twig'

local hlpr = assert(loadfile("project/helpers.lua"))(cef)

local tinsert = table.insert
local tremove = table.remove

ffi.cdef[[

    typedef struct lj_fpool_finfo {

        char        id[32];
        char        fname[1024];
        char        ext[8];
        void *      data;
        char *      body;
    
        char        mime_type[32];
        int         index;
        int         state;
        int         size;
        int         remaining;
    
    } lj_fpool_finfo;  


    void * calloc( size_t count, size_t esize );
]]

-- Namespace caching is faster
local fpool_cef = ffi.C 

-----------------------------------------------------------------------------------------------
-- File pool for loading multiple files

local max_htmlsize      = 2 * 1024 * 1024
local mime_types = {}
mime_types["adf"]       = "application/octet-stream"
mime_types["bin"]       = "application/octet-stream"
mime_types["css"]       = "text/css"
mime_types["gif"]       = "image/gif"
mime_types["gltf"]      = "model/gltf+json"
mime_types["glsl"]      = "text/plain"
mime_types["html"]      = "text/html"
mime_types["jpeg"]      = "image/jpeg"
mime_types["jpg"]       = "image/jpeg"
mime_types["js"]        = "text/javascript"
mime_types["json"]      = "application/json"
mime_types["mpeg"]      = "video/mpeg"
mime_types["png"]       = "image/png"
mime_types["svg"]       = "image/svg+xml"
mime_types["tif"]       = "image/tiff"
mime_types["tiff"]      = "image/tiff"
mime_types["txt"]       = "text/plain"
mime_types["weba"]      = "audio/webm"
mime_types["webm"]      = "video/webm"
mime_types["webp"]      = "image/webp"
mime_types["woff"]      = "font/woff"
mime_types["woff2"]     = "font/woff2"
mime_types["xml"]       = "text/xml"

mime_types["twig"]      = "text/html"

local fpool                 = {}
local fpool_scheme          = "custom"

-----------------------------------------------------------------------------------------------

local function init( www_paths )

    twig.init( www_paths )    
end    

-----------------------------------------------------------------------------------------------
local function pool_loadfile( filename_in, command, data_in )

    local mime_type_out = data_in[0].mime_type
    local path_in       = data_in[0].path
    local finfo         = nil
    local id            = tostring( ffi.string(filename_in) )

    local cmd           = ffi.string(command)

    if(cmd  == "load_data") then 

        -- if(fpool[id] == nil) then 

            finfo           = ffi.new("struct lj_fpool_finfo[1]")
            local filename  = ffi.string(filename_in)
            local pathname  = ffi.string(path_in)

            filename = string.sub( filename, #fpool_scheme + 4, -1 )
            filename        = string.match(filename, "([^%?]+)")

            ffi.fill(finfo[0].fname, 1024 )
            ffi.copy(finfo[0].fname, ffi.string(filename, #filename), #filename)

            local ext = string.match(filename, "^.+%.(.+)")
            ffi.fill(finfo[0].ext, #fpool_scheme + 3 )
            ffi.copy(finfo[0].ext, ffi.string(ext), #ext)

            local mimet = mime_types[ext]
            if(mimet == nil) then mimet = "text/html" end
            local mime_type = ffi.string(mimet, #mimet)

            ffi.fill(finfo[0].mime_type, 32)
            ffi.copy(finfo[0].mime_type, mime_type, #mime_type)
            -- print( newfile.mime_type, ext, fname )

            -- print("Filename:", finfo.fname)
            -- print("Extension:", finfo.ext)
            local data      = nil
            local dsize     = 0

            local filename  = ffi.string(finfo[0].fname)
            local ext       = ffi.string(finfo[0].ext)

            if(ext == "twig") then 
                -- print("File Twig Load: ", filename)
                data, dsize = twig.parse(filename)
            else 
                -- print("File Load: ", filename)
                -- Sometimes the filename is added as a "hostname". Usually because its a 
                --  relative file path from the document. Rebuild path if so.
                if(#pathname > 0) then filename = pathname end
                data, dsize = twig.readfile(filename)
            end 

            finfo[0].remaining     = dsize or 0
            -- finfo[0].state         = fpool_cef.FR_PENDINGFILE
            finfo[0].size          = dsize or 0

            -- fpool_cef.ljq_datanew( finfo[0].data,  dsize );
            -- local rawdata           = ffi.new("char[?]", dsize)

            local filedata         = ffi.cast("char *", ffi.string(data, dsize))
            finfo[0].body          = ffi.new("char[?]", dsize)
            ffi.copy( finfo[0].body, filedata, dsize)

            fpool[id] = finfo
        -- else 
        --     finfo = fpool[id]
        -- end
        data_in[0].dsize = finfo[0].size
    end

    if( cmd == "copy_data") then
        finfo = fpool[id]
        if( finfo ) then 
            ffi.copy( data_in[0].data, finfo[0].body, finfo[0].size)
            ffi.copy( mime_type_out, finfo[0].mime_type, 32)
        end 
    end
end


-----------------------------------------------------------------------------------------------

return {
    init = init,
    pool_loadfile   = pool_loadfile,
}