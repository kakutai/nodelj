
local ffi = require( "ffi" )

local libs = ffi_cef_lib or {
   Windows = { x64 = "bin/windows/libcef.dll" },
   OSX     = { x64 = "bin/osx/libcef.dylib" },
   Linux   = { x64 = "bin/linux/libcef.so", arm = "libcef" },
}

local cef = ffi.load( ffi_cef_lib or libs[ ffi.os ][ ffi.arch ] or "libcef" )

io.input( "ffi/libcef.h" )
ffi.cdef( io.read( "*all" ) )

return cef