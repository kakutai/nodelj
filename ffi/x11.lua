-----------------------------------------------------------------------------------------------
local ffi = require 'ffi'

local x11 = ffi.load("libX11")
ffi.cdef[[

    typedef struct {

        int type;
        void *display;  /* Display the event was read from */
        unsigned long serial;/* serial number of failed request */
        unsigned char error_code;/* error code of failed request */
        unsigned char request_code;/* Major op-code of failed request */
        unsigned char minor_code;/* Minor op-code of failed request */
        long resourceid; /* resource id */    
    } XErrorEvent;

    typedef int (*err_handler)(void *, XErrorEvent *);
    typedef int (*ioerr_handler)(void *);

    int XSetErrorHandler(err_handler);
    int XSetIOErrorHandler(ioerr_handler);
    int XGetErrorText(void *display, int code, char *buffer_return, int length);    

    unsigned int sleep(unsigned int seconds);
    int usleep(unsigned long usec);
]]

return x11