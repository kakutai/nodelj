gcc library.cc -fPIC -shared `kg-config --cflags --libs gtk+-3.0 webkit2gtk-4.0` -o webview.so

cp webview.so ../../bin/linux/webview.so
