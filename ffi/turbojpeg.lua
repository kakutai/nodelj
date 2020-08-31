
local ffi = require("ffi")

local libs = ffi_luajit_libs or {
   OSX     = { x86 = "bin/OSX/libturbojpeg.0.2.0.dylib", x64 = "bin/OSX/libturbojpeg.0.2.0.dylib" },
   Windows = { x86 = "bin/windows/x86/turbojpeg.dll", x64 = "bin/windows/x64/turbojpeg.dll" },
   Linux   = { x86 = "SDL", x64 = "bin/Linux/x64/libturbojpeg.so.0.2.0", arm = "bin/Linux/arm/libturbojpeg.so.0.2.0" },
}

local turbojpeg  = ffi.load( libs[ ffi.os ][ ffi.arch ]  or "turbojpeg" )

ffi.cdef[[

static const int TJ_NUMSAMP = 6;
static const int TJ_NUMPF = 12;

static const int TJ_NUMCS =  5;

static const int TJFLAG_BOTTOMUP = 2;
static const int TJFLAG_FASTUPSAMPLE = 256;
static const int TJFLAG_NOREALLOC = 1024;
static const int TJFLAG_FASTDCT = 2048;
static const int TJFLAG_ACCURATEDCT = 4096;
static const int TJFLAG_STOPONWARNING = 8192;
static const int TJFLAG_PROGRESSIVE = 16384;

static const int TJ_NUMERR = 2;
static const int TJ_NUMXOP = 8;

static const int TJXOPT_PERFECT = 1;
static const int TJXOPT_TRIM = 2;
static const int TJXOPT_CROP = 4;
static const int TJXOPT_GRAY = 8;
static const int TJXOPT_NOOUTPUT = 16;
static const int TJXOPT_PROGRESSIVE = 32;   
static const int TJXOPT_COPYNONE = 64;

enum {
 
 TJSAMP_444 = 0,
 
 TJSAMP_422,
 
 TJSAMP_420,
 
 TJSAMP_GRAY,
 
 TJSAMP_440,
 
 TJSAMP_411
};

enum TJPF {
 
 TJPF_RGB = 0,
 
 TJPF_BGR,
 
 TJPF_RGBX,
 
 TJPF_BGRX,
 
 TJPF_XBGR,
 
 TJPF_XRGB,
 
 TJPF_GRAY,
 
 TJPF_RGBA,
 
 TJPF_BGRA,
 
 TJPF_ABGR,
 
 TJPF_ARGB,
 
 TJPF_CMYK,
 
 TJPF_UNKNOWN = -1
};

enum TJCS {
 
 TJCS_RGB = 0,
 
 TJCS_YCbCr,
 
 TJCS_GRAY,
 
 TJCS_CMYK,
 
 TJCS_YCCK
};



enum {
 
 TJERR_WARNING = 0,
 
 TJERR_FATAL
};


enum {
 
 TJXOP_NONE = 0,
 
 TJXOP_HFLIP,
 
 TJXOP_VFLIP,
 
 TJXOP_TRANSPOSE,
 
 TJXOP_TRANSVERSE,
 
 TJXOP_ROT90,
 
 TJXOP_ROT180,
 
 TJXOP_ROT270
};


typedef struct {
 
 int num;
 
 int denom;
} tjscalingfactor;


typedef struct {
 
 int x;
 
 int y;
 
 int w;
 
 int h;
} tjregion;


typedef struct tjtransform {
 
 tjregion r;
 
 int op;
 
 int options;
 
 void *data;
 
 int (*customFilter) (short *coeffs, tjregion arrayRegion,
                      tjregion planeRegion, int componentIndex,
                      int transformIndex, struct tjtransform *transform);
} tjtransform;


typedef void *tjhandle;



inline int TJPAD(int width) { return (((width) + 3) & (~3)); }


inline int TJSCALED(int dimension, int scalingFactor){
    return ((dimension * scalingFactor.num + scalingFactor.denom - 1)
        scalingFactor.denom)
}


tjhandle tjInitCompress(void);



 int tjCompress2(tjhandle handle, const unsigned char *srcBuf,
                         int width, int pitch, int height, int pixelFormat,
                         unsigned char **jpegBuf, unsigned long *jpegSize,
                         int jpegSubsamp, int jpegQual, int flags);



 int tjCompressFromYUV(tjhandle handle, const unsigned char *srcBuf,
                               int width, int pad, int height, int subsamp,
                               unsigned char **jpegBuf,
                               unsigned long *jpegSize, int jpegQual,
                               int flags);



 int tjCompressFromYUVPlanes(tjhandle handle,
                                     const unsigned char **srcPlanes,
                                     int width, const int *strides,
                                     int height, int subsamp,
                                     unsigned char **jpegBuf,
                                     unsigned long *jpegSize, int jpegQual,
                                     int flags);



 unsigned long tjBufSize(int width, int height, int jpegSubsamp);



 unsigned long tjBufSizeYUV2(int width, int pad, int height,
                                     int subsamp);



 unsigned long tjPlaneSizeYUV(int componentID, int width, int stride,
                                      int height, int subsamp);



 int tjPlaneWidth(int componentID, int width, int subsamp);



 int tjPlaneHeight(int componentID, int height, int subsamp);



 int tjEncodeYUV3(tjhandle handle, const unsigned char *srcBuf,
                          int width, int pitch, int height, int pixelFormat,
                          unsigned char *dstBuf, int pad, int subsamp,
                          int flags);



 int tjEncodeYUVPlanes(tjhandle handle, const unsigned char *srcBuf,
                               int width, int pitch, int height,
                               int pixelFormat, unsigned char **dstPlanes,
                               int *strides, int subsamp, int flags);



 tjhandle tjInitDecompress(void);



 int tjDecompressHeader3(tjhandle handle,
                                 const unsigned char *jpegBuf,
                                 unsigned long jpegSize, int *width,
                                 int *height, int *jpegSubsamp,
                                 int *jpegColorspace);



 tjscalingfactor *tjGetScalingFactors(int *numscalingfactors);



 int tjDecompress2(tjhandle handle, const unsigned char *jpegBuf,
                           unsigned long jpegSize, unsigned char *dstBuf,
                           int width, int pitch, int height, int pixelFormat,
                           int flags);



 int tjDecompressToYUV2(tjhandle handle, const unsigned char *jpegBuf,
                                unsigned long jpegSize, unsigned char *dstBuf,
                                int width, int pad, int height, int flags);



 int tjDecompressToYUVPlanes(tjhandle handle,
                                     const unsigned char *jpegBuf,
                                     unsigned long jpegSize,
                                     unsigned char **dstPlanes, int width,
                                     int *strides, int height, int flags);



 int tjDecodeYUV(tjhandle handle, const unsigned char *srcBuf,
                         int pad, int subsamp, unsigned char *dstBuf,
                         int width, int pitch, int height, int pixelFormat,
                         int flags);



 int tjDecodeYUVPlanes(tjhandle handle,
                               const unsigned char **srcPlanes,
                               const int *strides, int subsamp,
                               unsigned char *dstBuf, int width, int pitch,
                               int height, int pixelFormat, int flags);



 tjhandle tjInitTransform(void);



 int tjTransform(tjhandle handle, const unsigned char *jpegBuf,
                         unsigned long jpegSize, int n,
                         unsigned char **dstBufs, unsigned long *dstSizes,
                         tjtransform *transforms, int flags);



 int tjDestroy(tjhandle handle);



 unsigned char *tjAlloc(int bytes);



 unsigned char *tjLoadImage(const char *filename, int *width,
                                    int align, int *height, int *pixelFormat,
                                    int flags);



 int tjSaveImage(const char *filename, unsigned char *buffer,
                         int width, int pitch, int height, int pixelFormat,
                         int flags);



 void tjFree(unsigned char *buffer);



 char *tjGetErrorStr2(tjhandle handle);



 int tjGetErrorCode(tjhandle handle);


/* Deprecated functions and macros */
static const int TJFLAG_FORCEMMX  = 8;
static const int TJFLAG_FORCESSE  = 16;
static const int TJFLAG_FORCESSE2  = 32;
static const int TJFLAG_FORCESSE3  = 128;


/* Backward compatibility functions and macros (nothing to see here) */
static const int NUMSUBOPT  = TJ_NUMSAMP;
static const int TJ_444  = TJSAMP_444;
static const int TJ_422  = TJSAMP_422;
static const int TJ_420  = TJSAMP_420;
static const int TJ_411  = TJSAMP_420;
static const int TJ_GRAYSCALE  = TJSAMP_GRAY;

static const int TJ_BGR  = 1;
static const int TJ_BOTTOMUP  = TJFLAG_BOTTOMUP;
static const int TJ_FORCEMMX  = TJFLAG_FORCEMMX;
static const int TJ_FORCESSE  = TJFLAG_FORCESSE;
static const int TJ_FORCESSE2  = TJFLAG_FORCESSE2;
static const int TJ_ALPHAFIRST  = 64;
static const int TJ_FORCESSE3  = TJFLAG_FORCESSE3;
static const int TJ_FASTUPSAMPLE  = TJFLAG_FASTUPSAMPLE;
static const int TJ_YUV  = 512;

 unsigned long TJBUFSIZE(int width, int height);

 unsigned long TJBUFSIZEYUV(int width, int height, int jpegSubsamp);

 unsigned long tjBufSizeYUV(int width, int height, int subsamp);

 int tjCompress(tjhandle handle, unsigned char *srcBuf, int width,
                        int pitch, int height, int pixelSize,
                        unsigned char *dstBuf, unsigned long *compressedSize,
                        int jpegSubsamp, int jpegQual, int flags);

 int tjEncodeYUV(tjhandle handle, unsigned char *srcBuf, int width,
                         int pitch, int height, int pixelSize,
                         unsigned char *dstBuf, int subsamp, int flags);

 int tjEncodeYUV2(tjhandle handle, unsigned char *srcBuf, int width,
                          int pitch, int height, int pixelFormat,
                          unsigned char *dstBuf, int subsamp, int flags);

 int tjDecompressHeader(tjhandle handle, unsigned char *jpegBuf,
                                unsigned long jpegSize, int *width,
                                int *height);

 int tjDecompressHeader2(tjhandle handle, unsigned char *jpegBuf,
                                 unsigned long jpegSize, int *width,
                                 int *height, int *jpegSubsamp);

 int tjDecompress(tjhandle handle, unsigned char *jpegBuf,
                          unsigned long jpegSize, unsigned char *dstBuf,
                          int width, int pitch, int height, int pixelSize,
                          int flags);

 int tjDecompressToYUV(tjhandle handle, unsigned char *jpegBuf,
                               unsigned long jpegSize, unsigned char *dstBuf,
                               int flags);

 char *tjGetErrorStr(void);

]] 

local tbls = {
tjMCUWidth = { [0]=8, 16, 16, 8, 8, 32 },
tjMCUHeight = { [0]=8, 8, 16, 8, 16, 8 },

tjRedOffset = { [0]=0, 2, 0, 2, 3, 1, -1, 0, 2, 3, 1, -1 },
tjGreenOffset = { [0]=1, 1, 1, 1, 2, 2, -1, 1, 1, 2, 2, -1 },
tjBlueOffset = { [0]=2, 0, 2, 0, 1, 3, -1, 2, 0, 1, 3, -1 },
tjAlphaOffset = { [0]=-1, -1, -1, -1, -1, -1, -1, 3, 3, 0, 0, -1 },
tjPixelSize = { [0]=3, 3, 4, 4, 4, 4, 1, 4, 4, 4, 4, 4 }
}


return turbojpeg