local ffi  = require( "ffi" )

local libs = ffi_assimp_libs or {
   OSX     = { x86 = "bin/osx/libassimp.dylib",       x64 = "bin/osx/libassimp.dylib" },
   Windows = { x86 = "bin/windows/x86/libassimp.dll", x64 = "bin/windows/x64/libassimp.dll" },
   Linux   = { x86 = "bin/linux/x86/libassimp.so.5.0.1", x64 = "bin/linux/x64/libassimp.so.5.0.1",
	       arm = "bin/linux/arm/libassimp.so"  },
   BSD     = { x86 = "bin/libassimp.so", x64 = "bin/libassimp.so" },
   POSIX   = { x86 = "bin/libassimp.so", x64 = "bin/libassimp.so" },
   Other   = { x86 = "bin/libassimp.so", x64 = "bin/libassimp.so" },
}

local assimp = ffi.load( ffi_assimp_lib or libs[ ffi.os ][ ffi.arch ] or "libglfw" )

io.input( "ffi/libassimp.h" )
ffi.cdef( io.read( "*all" ) )

return assimp