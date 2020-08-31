local ffi = require 'ffi'
local extensions = {}
print(ffi.os)
---------------------------------------------------------------------------------------
local jpeglib = {
   ["Linux"] = "./bin/linux/x64/libjpeg.so",
   ["Windows"] = "jpeg.dll",
}


extensions.jpg = ffi.load(jpeglib[ffi.os])
ffi.cdef[[
   typedef void (*jpeg_func)(void *context, void *data, int size);
   int writefile(const char *filename, int w, int h, int comp, const char * data, int quality);
   int writefunc(jpeg_func func, void *ctx, int x, int y, int comp, const char *data, int quality);
]]

if os.ffi == "Windows" then 

extensions.gdi = ffi.load("gdi32")
ffi.cdef[[
   typedef void *			HANDLE;
   typedef HANDLE       HDC;
   typedef HANDLE       HWND;
   typedef HANDLE       HGLRC;
   typedef HANDLE       HBITMAP;
   
   typedef uint32_t     DWORD;
   typedef uint32_t     UINT;

   HDC      CreateCompatibleDC(HDC device);
   HBITMAP  CreateBitmap(int nWidth, int nHeight, UINT nPlanes, UINT nBitCount, const void *lpBits);   
   HBITMAP  CreateCompatibleBitmap( HDC device, int width, int height);
   void     SelectObject(HDC dc, HBITMAP bitmap);
   void     BitBlt(HDC src, int px, int py, int width, int height, HDC dst, int dx, int dy, int mode);
   bool     StretchBlt(HDC hdcDest,int xDest, int yDest, int wDest, int hDest,
                        HDC hdcSrc, int xSrc, int ySrc, int wSrc, int hSrc, DWORD rop);
   
   int      GetBitmapBits(HBITMAP hbit, int cb, void *lpvBits);
   bool     DeleteObject(HANDLE obj);
   void     DeleteDC(HDC dc);
]]

extensions.usr = ffi.load("user32")
ffi.cdef[[

   static const int MONITOR_DEFAULTTONULL      = 0x00000000;
   static const int MONITOR_DEFAULTTOPRIMARY   = 0x00000001;
   static const int MONITOR_DEFAULTTONEAREST   = 0x00000002;

   static const int INPUT_MOUSE       = 0;
   static const int INPUT_KEYBOARD    = 1;
   static const int INPUT_HARDWARE    = 2;

   static const int KEYEVENTF_EXTENDEDKEY  = 0x0001;
   static const int KEYEVENTF_KEYUP        = 0x0002;
   static const int KEYEVENTF_SCANCODE     = 0x0008;
   static const int VK_LCONTROL            = 0xA2; //Left Control key code
   static const int VK_MENU                = 0x12; //Alt key code
   static const int VK_UP                  = 0x26; //Up cursor key code

   static const int MOUSEEVENTF_MOVE = 1;
   static const int MOUSEEVENTF_LEFTDOWN = 2;
   static const int MOUSEEVENTF_LEFTUP = 4;
   static const int MOUSEEVENTF_RIGHTDOWN = 8;
   static const int MOUSEEVENTF_RIGHTUP = 16;
   static const int MOUSEEVENTF_MIDDLEDOWN = 32;
   static const int MOUSEEVENTF_MIDDLEUP = 64;
   
   static const int MOUSEEVENTF_WHEEL = 0x0800;
   static const int MOUSEEVENTF_VIRTUALDESK = 0x4000;
   static const int MOUSEEVENTF_ABSOLUTE = 0x8000;   

   static const int SM_XVIRTUALSCREEN  = 76;
   static const int SM_YVIRTUALSCREEN  = 77;
   static const int SM_CXVIRTUALSCREEN = 78;
   static const int SM_CYVIRTUALSCREEN = 79;
   static const int SM_CMONITORS       = 80;

   typedef void *			HANDLE;
   typedef HANDLE       HDC;
   typedef HANDLE       HWND;
   typedef HANDLE       HGLRC;
   typedef HANDLE       HBITMAP;
   typedef HANDLE       HMONITOR;

   typedef uint32_t     DWORD;
   typedef int32_t      LONG;
   typedef uint32_t     ULONG;
   typedef intptr_t     ULONG_PTR;
   typedef uint32_t     UINT;
   
   typedef uint16_t     WORD;
   typedef uint16_t     SHORT;
   
   typedef char         CHAR;
   
   typedef void *       LPINPUT;

   typedef struct tagPOINT {
      LONG x;
      LONG y;
    } POINT, *PPOINT;

   typedef struct tagRECT {
      LONG left;
      LONG top;
      LONG right;
      LONG bottom;
   } RECT, *PRECT, *NPRECT, *LPRECT;

   typedef struct MONITORINFO {
      DWORD cbSize;
      RECT  rcMonitor;
      RECT  rcWork;
      DWORD dwFlags;
   } MONITORINFO;   

   HWND GetDesktopWindow();
   HMONITOR MonitorFromWindow(HWND hwnd, DWORD dwFlags );   
   int GetMonitorInfoA( HMONITOR hMonitor, MONITORINFO * lpmi );
   int PhysicalToLogicalPoint(HWND hWnd, POINT * lpPoint);
   int LogicalToPhysicalPoint( HWND hWnd, POINT * lpPoint );
   int ClientToScreen(HWND    hWnd, POINT * lpPoint);   
   int GetSystemMetrics(int nIndex);

   typedef struct MOUSEINPUT {
      LONG      dx;
      LONG      dy;
      DWORD     mouseData;
      DWORD     dwFlags;
      DWORD     time;
      ULONG_PTR dwExtraInfo;
   } MOUSEINPUT, *PMOUSEINPUT, *LPMOUSEINPUT;

    typedef struct KEYBDINPUT {
      WORD      wVk;
      WORD      wScan;
      DWORD     dwFlags;
      DWORD     time;
      ULONG_PTR dwExtraInfo;
   } KEYBDINPUT, *PKEYBDINPUT, *LPKEYBDINPUT;

   typedef struct HARDWAREINPUT {
      DWORD uMsg;
      WORD  wParamL;
      WORD  wParamH;
   } HARDWAREINPUT, *PHARDWAREINPUT, *LPHARDWAREINPUT;

   typedef struct MINPUT {
      DWORD type;
      MOUSEINPUT    mi;
   } MINPUT;

   typedef struct KINPUT {
      DWORD type;
      KEYBDINPUT    ki;
   } KINPUT;

   typedef struct HINPUT {
      DWORD type;
      HARDWAREINPUT hi;
   } HINPUT;
 
   HDC      GetDC(HWND hWnd);
   void     ReleaseDC(HWND win, HDC dc);
   HANDLE   CopyImage( HANDLE h, UINT type, int cx, int cy, UINT flags);       

   UINT SendInput(UINT cInputs, LPINPUT pInputs, int cbSize);
   SHORT VkKeyScanExA(CHAR ch, int  dwhkl);
   UINT MapVirtualKeyA(UINT uCode, UINT uMapType);
]]

extensions.kern = ffi.load("kernel32")
ffi.cdef[[

   static const int  FORMAT_MESSAGE_ALLOCATE_BUFFER   = 0x00000100;
   static const int  FORMAT_MESSAGE_FROM_SYSTEM       = 0x00001000;
   static const int  FORMAT_MESSAGE_IGNORE_INSERTS    = 0x00000200;

   typedef uint32_t     DWORD;
   typedef DWORD *      DWORD_PTR;
   typedef char **      LPTSTR;
   typedef void *       LPVOID;

   DWORD GetLastError();
   DWORD FormatMessageA(DWORD dwFlags, LPVOID lpSource, DWORD dwMessageId, 
                        DWORD dwLanguageId, LPTSTR lpBuffer, DWORD nSize, DWORD_PTR Arguments );   
   void Sleep(DWORD dwMilliseconds);
]]

end -- Windows

extensions.util = {
   ErrorMessage = function() 

      local lpMsgBuf = ffi.new("char *[1]")
      local dw = extensions.kern.GetLastError()
  
      extensions.kern.FormatMessageA(
          bit.bor(bit.bor(extensions.kern.FORMAT_MESSAGE_ALLOCATE_BUFFER, extensions.kern.FORMAT_MESSAGE_FROM_SYSTEM),
                        extensions.kern.FORMAT_MESSAGE_IGNORE_INSERTS),
          nil,
          dw,
          0,
          lpMsgBuf,
          0, nil )  
      local cptr = ffi.new("char*[1]", lpMsgBuf)          
      return dw, ffi.string(cptr[0])
   end
}

return extensions

---------------------------------------------------------------------------------------
