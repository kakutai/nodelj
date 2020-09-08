
local ffi = require( "ffi" )

local libs = ffi_wv_lib or {
   Windows = { x86 = "bin/windows/x86/webview.dll", x64 = "bin/windows/x64/webview.dll" },
   OSX     = { x86 = "bin/osx/webview.dylib", x64 = "bin/osx/webview.dylib" },
   Linux   = { x86 = "bin/linux/x64/webview.so", x64 = "bin/linux/x64/webview.so", arm = "webview" },
}

local wv = ffi.load( ffi_wv_lib or libs[ ffi.os ][ ffi.arch ] or "webview" )

ffi.cdef[[

    /* Used in the file pool loader. */
    typedef struct lj_data_in {
    
        char *          data;
        char            mime_type[32];
        int             dsize;
        const char *    path;
    
    } lj_data_in;
    
    /* Callback from JS for global space command that can be bound to JS. */
    typedef void (*lj_webview_func)(const char *seq, const char *req, void *arg);
    void webViewBindOperation( void *w, const char *op, lj_webview_func func, void *arg);

    /* Function callback for file streaming. This is called when a file open is initiated. */
    typedef void (* fpool_callback)( const char *filename, const char * op, struct lj_data_in *datain );
    typedef void (* js_callback)( const char *results );

    void *webViewCreate();
    void webViewSetTitle( void *w, const char *title);
    void webViewSetSize( void *w, int width, int height );

    void webViewHandleScheme( void *w, const char *schemename, fpool_callback callback );
    void webViewNavigate( void *w, const char *url );
    void webViewRun( void *w );
    void webViewDestroy(void *w );

    void webViewEnableInspector( void *w );
    void webViewRunJS( void *w, const char *script, js_callback lj_callback );
]]

return wv