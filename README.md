# nodelj

Nodelj is intended to be a luajit version of Nodejs. The current implementation is a base framework only. 
Current features:
- Webkit ffi library (currently Linux build - Win and OSX to be added)
- Interface to files for the Webkit engine.
- JavaScript interface for calling into Luajit.
- Luajit eval for accessing variables in JavaScript.
- Twig compatible templating (local and remote).

Standalone Luajit implementation which means:
- Access to a huge number of ffi libraries
- Use of standard Lua libraries
- Easy to add your own interfaces with ffi

The toolkit is being used in the creation of 3D tools for the web. Some example screenshots are shown below. 

<screenshots>

This work is based on the brilliant libraries and tools of:
- Luajit:                       https://luajit.org/
- Webview Lua ffi bindings:     https://github.com/webview/webview
- Aspect:                       https://github.com/unifire-app/aspect

Similar projects:
- Luakit: https://github.com/luakit-crowd/luakit
