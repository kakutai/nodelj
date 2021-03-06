
package.path = package.path..";lua/?.lua;lua/?/init.lua"
package.path = package.path..";ffi/?.lua;ffi/?/init.lua"
package.path = package.path..";deps/?.lua;deps/?/init.lua"
package.path = package.path..";project/?.lua"
package.path = package.path..";project/scripts/?.lua"
package.path = package.path..";project/scripts/?/init.lua"

-----------------------------------------------------------------------------------------------
local ffi = require 'ffi'
local ffiext = require 'ffi-extensions'
local utils = require 'utils'

local p = require('pprint').prettyPrint

local stp = require('scripts.stacktraceplus')
debug.traceback = stp.stacktrace

-----------------------------------------------------------------------------------------------
-- Must be declared before uv-ffi if using http-parser
-- local httpp = require "http_parser_ffi"

-- local loop = require 'uv-ffi'
-- local lutem = require 'lutem'

local b64 = require 'base64'
local utf8 = require 'utf8string'

-----------------------------------------------------------------------------------------------
-- X11 has some sleep functions if needed.
-- local x11 = require 'x11'
local wv = require 'webview'
local assimp = require 'assimp'

local eps = ffi.new("uint32_t[1]", assimp.ai_epsilon)
local epsf = ffi.new("float[1]", ffi.cast("float *", eps)[0])

-----------------------------------------------------------------------------------------------

local shr, band = bit.rshift, bit.band
local hlpr = require 'helpers'
-- local hlpr = require 'helpers', cef

-----------------------------------------------------------------------------------------------

local progname = ... or (arg and arg[0]) or "README"

local configs = require('project.configs.main')

-----------------------------------------------------------------------------------------------

local www = configs.google
if( www["www_dir"] == nil ) then www.www_dir = "custom://" end

local fpool = require 'scripts/file_pool'
fpool.init( www )

local wvobj = wv.webViewCreate()

-----------------------------------------------------------------------------------------------
-- Register scheme callback - change scheme above for your own scheme.

local function fpool_readfile( filename, dataptr, sizeptr, mime_type )

    fpool.pool_loadfile( filename, dataptr, sizeptr, mime_type )
end

-----------------------------------------------------------------------------------------------
-- Main stuff

wv.webViewSetTitle( wvobj, www.title )
wv.webViewSetSize( wvobj, 1280, 900 )

wv.webViewHandleScheme( wvobj, "custom", fpool_readfile )

if( www.register ~= nil ) then 
    if(www.register.init) then www.register.init( wv, wvobj ) end
    for k, v in pairs( www.register ) do
        if( k ~= "init" ) then
            wv.webViewBindOperation( wvobj, v.funcname, v.func, v.args )
        end
    end
end

wv.webViewNavigate( wvobj, www.url_start )

-- NOTE: Enable this to view debug at start. This can be put in JS callbacks too. 
-- wv.webViewEnableInspector( wvobj )
wv.webViewRun( wvobj )

-----------------------------------------------------------------------------------------------
