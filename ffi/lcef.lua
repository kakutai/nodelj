
local ffi = require( "ffi" )

local libs = ffi_cef_lib or {
   Windows = { x86 = "bin/windows/x86/libcef.dll", x64 = "bin/windows/x64/libcef.dll" },
   OSX     = { x86 = "bin/osx/libcef.dylib", x64 = "bin/osx/libcef.dylib" },
   Linux   = { x86 = "bin/linux/x64/libcef.so", x64 = "bin/linux/x64/libcef.so", arm = "libcef" },
}

local cef = ffi.load( ffi_cef_lib or libs[ ffi.os ][ ffi.arch ] or "libcef" )

io.input( "ffi/libcef.h" )
ffi.cdef( io.read( "*all" ) )

return cef