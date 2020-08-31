//bin/echo; [ $(uname) = "Darwin" ] && FLAGS="-framework Webkit" || FLAGS="$(pkg-config --cflags --libs gtk+-3.0 webkit2gtk-4.0)" ; c++ "$0" $FLAGS -std=c++11 -g -o webview && ./webview ; exit
// +build ignore

#include "webview.h"

#include <iostream>

typedef struct lj_data_in {
    
    char *          data;
    char            mime_type[32];
    int             dsize;
    const gchar *   path;

} lj_data_in;

typedef void (* fpool_callback)( const char *filename, const char *op, struct lj_data_in *datain );

extern "C" void *webViewCreate()
{
    webview::webview *w = new webview::webview(true, nullptr);
    return w;
}

extern "C" void webViewSetTitle( webview::webview *w, const char *title)
{
    w->set_title(title);
}

extern "C" void webViewSetSize( webview::webview *w, int width, int height )
{
    w->set_size(width, height, WEBVIEW_HINT_NONE);
    w->set_size(180, 120, WEBVIEW_HINT_MIN);
}

// Bind a function to a global var in JS. 
// NOTES: func must take a const char * param, and return const char * param.
// typedef void (*lj_webview_func)(const char *seq, const char *req, void *arg);
extern "C" void webViewBindOperation( webview::webview *w, const char *op, lj_webview_func func, void *arg)
{ 
  w->bind(
      op,
      [=](std::string seq, std::string req, void *arg) {
        func(seq.c_str(), req.c_str(), arg);
      },
      arg);
}

static void handle_custom(WebKitURISchemeRequest *request, gpointer user_data)
{
    GInputStream *      stream;
    static struct lj_data_in datain;
    const gchar *       uri;

    if(user_data != NULL) {

        fpool_callback  fpool_func = (fpool_callback)(user_data);

        //datain = (struct lj_data_in *)calloc(1, sizeof(struct lj_data_in));
        uri = webkit_uri_scheme_request_get_uri(request);
        datain.path = webkit_uri_scheme_request_get_path(request);
        fpool_func( uri, "load_data", &datain );
    
        datain.data = (char *) calloc(1, datain.dsize);       
        fpool_func( uri, "copy_data", &datain );

        // if(strstr(uri, "seer-viewer") != NULL) {            
            // printf("%s  %d\n", mime_type, dsize);
        // }

        stream = g_memory_input_stream_new_from_data( datain.data, datain.dsize, g_free );
        webkit_uri_scheme_request_finish(request, stream, datain.dsize, datain.mime_type);
        g_object_unref(stream);
    }
}   

extern "C" void webViewHandleScheme( webview::webview *w, const char *schemename, fpool_callback callback )
{
    WebKitWebContext *context = webkit_web_context_get_default();
    webkit_web_context_register_uri_scheme(context, schemename,
        (WebKitURISchemeRequestCallback)handle_custom, (void *)callback, NULL);
    WebKitSecurityManager * sm = webkit_web_context_get_security_manager(context);
    //webkit_security_manager_register_uri_scheme_as_cors_enabled( sm, schemename );
    webkit_security_manager_register_uri_scheme_as_local( sm, schemename );
}

extern "C" void webViewNavigate( webview::webview *w, const char *url )
{
    w->navigate(url);
}

extern "C" void webViewRun( webview::webview *w )
{
     w->run();
}

extern "C" void webViewDestroy( webview::webview *w )
{
     w->destroy();
}

extern "C" void webViewEnableInspector( webview::webview *w )
{
    w->enable_inspector();
}