gcc library.cc -fPIC -shared `pkg-config --cflags --libs gtk+-3.0 webkit2gtk-4.0` -o webview.so

cp webview.so ../../bin/linux/x64/webview.so
