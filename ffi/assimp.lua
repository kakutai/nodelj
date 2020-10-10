local ffi  = require( "ffi" )

local libs = ffi_assimp_libs or {
   OSX     = { x64 = "bin/osx/libassimp.dylib" },
   Windows = { x64 = "bin/windows/libassimp.dll" },
   Linux   = { x64 = "bin/linux/libassimp.so.5.0.1",
	       arm = "bin/linux/libassimp.so"  },
   BSD     = { x64 = "bin/libassimp.so" },
   POSIX   = { x64 = "bin/libassimp.so" },
   Other   = { x64 = "bin/libassimp.so" },
}

local assimp = ffi.load( ffi_assimp_lib or libs[ ffi.os ][ ffi.arch ] or "libglfw" )

io.input( "ffi/libassimp.h" )
ffi.cdef( io.read( "*all" ) )

return assimp