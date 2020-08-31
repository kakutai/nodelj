local ffi  = require( "ffi" )

local libs = ffi_glfw_libs or {
   OSX     = { x86 = "bin/osx/glfw.dylib",       x64 = "bin/osx/glfw.dylib" },
   Windows = { x86 = "bin/windows/x86/glfw.dll", x64 = "bin/windows/x64/glfw.dll" },
   Linux   = { x86 = "bin/linux/x86/libglfw.so.3.3", x64 = "bin/linux/x64/libglfw.so.3.3",
	       arm = "bin/linux/arm/libglfw.so"  },
   BSD     = { x86 = "bin/glfw32.so", x64 = "bin/glfw64.so" },
   POSIX   = { x86 = "bin/glfw32.so", x64 = "bin/glfw64.so" },
   Other   = { x86 = "bin/glfw32.so", x64 = "bin/glfw64.so" },
}

local glfw = ffi.load( ffi_glfw_lib or libs[ ffi.os ][ ffi.arch ] or "libglfw" )

io.input( "ffi/libglfw.h" )
ffi.cdef( io.read( "*all" ) )


return glfw