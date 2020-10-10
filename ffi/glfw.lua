local ffi  = require( "ffi" )

local libs = ffi_glfw_libs or {
   OSX     = { x64 = "bin/osx/glfw.dylib" },
   Windows = { x64 = "bin/windows/glfw.dll" },
   Linux   = { x64 = "bin/linux/libglfw.so.3.3",
	       arm = "bin/linux/libglfw.so"  },
   BSD     = { x64 = "bin/glfw64.so" },
   POSIX   = { x64 = "bin/glfw64.so" },
   Other   = { x64 = "bin/glfw64.so" },
}

local glfw = ffi.load( ffi_glfw_lib or libs[ ffi.os ][ ffi.arch ] or "libglfw" )

io.input( "ffi/libglfw.h" )
ffi.cdef( io.read( "*all" ) )


return glfw