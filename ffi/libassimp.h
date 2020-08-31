       




          


       




       



// // #include <limits.h>
 
// #include <stddef.h>
 
// #include <stdint.h>
 
// #include <string.h>
 
// #include <sys/types.h>


       




       


       
enum aiComponent
{




    aiComponent_NORMALS = 0x2u,






    aiComponent_TANGENTS_AND_BITANGENTS = 0x4u,




    aiComponent_COLORS = 0x8,



    aiComponent_TEXCOORDS = 0x10,




    aiComponent_BONEWEIGHTS = 0x20,




    aiComponent_ANIMATIONS = 0x40,


    aiComponent_TEXTURES = 0x80,




    aiComponent_LIGHTS = 0x100,




    aiComponent_CAMERAS = 0x200,


    aiComponent_MESHES = 0x400,



    aiComponent_MATERIALS = 0x800,





    _aiComponent_Force32Bit = 0x9fffffff

};
typedef float ai_real;
typedef signed int ai_int;
typedef unsigned int ai_uint;
static const uint32_t ai_epsilon = 0x3727c5ac; // 0.00001
       




          





 
// #include  <math.h>
struct aiVector2D {
    ai_real x, y;
};
       




          





 
// #include <math.h>
struct aiVector3D {
    ai_real x, y, z;
};
       




          
struct aiColor4D {
    ai_real r, g, b, a;
};
       




          
struct aiMatrix3x3 {
    ai_real a1, a2, a3;
    ai_real b1, b2, b3;
    ai_real c1, c2, c3;
};
       




          
struct aiMatrix4x4 {
    ai_real a1, a2, a3, a4;
    ai_real b1, b2, b3, b4;
    ai_real c1, c2, c3, c4;
    ai_real d1, d2, d3, d4;
};
       
struct aiQuaternion {
    ai_real w, x, y, z;
};

typedef int32_t ai_int32;
typedef uint32_t ai_uint32;
struct aiPlane {
    ai_real a, b, c, d;
};




struct aiRay {
    struct aiVector3D pos, dir;
};




struct aiColor3D {
    ai_real r, g, b;
};
struct aiString {
    ai_uint32 length;


    char data[1024];
};





typedef enum aiReturn {

    aiReturn_SUCCESS = 0x0,


    aiReturn_FAILURE = -0x1,




    aiReturn_OUTOFMEMORY = -0x3,




    _AI_ENFORCE_ENUM_SIZE = 0x7fffffff


} aiReturn;
enum aiOrigin {

    aiOrigin_SET = 0x0,


    aiOrigin_CUR = 0x1,


    aiOrigin_END = 0x2,




    _AI_ORIGIN_ENFORCE_ENUM_SIZE = 0x7fffffff


};






enum aiDefaultLogStream {

    aiDefaultLogStream_FILE = 0x1,


    aiDefaultLogStream_STDOUT = 0x2,


    aiDefaultLogStream_STDERR = 0x4,




    aiDefaultLogStream_DEBUGGER = 0x8,




    _AI_DLS_ENFORCE_ENUM_SIZE = 0x7fffffff

};
struct aiMemoryInfo {
    unsigned int textures;


    unsigned int materials;


    unsigned int meshes;


    unsigned int nodes;


    unsigned int animations;


    unsigned int cameras;


    unsigned int lights;


    unsigned int total;
};






       




          
       
       




          
       




          
       
       




          
       




          





enum aiImporterFlags {


    aiImporterFlags_SupportTextFlavour = 0x1,



    aiImporterFlags_SupportBinaryFlavour = 0x2,



    aiImporterFlags_SupportCompressedFlavour = 0x4,





    aiImporterFlags_LimitedSupport = 0x8,





    aiImporterFlags_Experimental = 0x10
};
struct aiImporterDesc {

    const char* mName;


    const char* mAuthor;


    const char* mMaintainer;


    const char* mComments;



    unsigned int mFlags;




    unsigned int mMinMajor;
    unsigned int mMinMinor;







    unsigned int mMaxMajor;
    unsigned int mMaxMinor;
    const char* mFileExtensions;
};







__attribute__((visibility("default"))) const struct aiImporterDesc* aiGetImporterDesc( const char *extension );






struct aiScene;
struct aiFileIO;
typedef void (*aiLogStreamCallback)(const char* , char* );
struct aiLogStream
{

    aiLogStreamCallback callback;


    char* user;
};
struct aiPropertyStore { char sentinel; };


typedef int aiBool;

__attribute__((visibility("default"))) 
          const 
                struct 
                         aiScene* aiImportFile(
    const char* pFile,
    unsigned int pFlags);

__attribute__((visibility("default"))) 
          const 
                struct 
                         aiScene* aiImportFileEx(
    const char* pFile,
    unsigned int pFlags,
    
   struct 
            aiFileIO* pFS);

__attribute__((visibility("default"))) 
          const 
                struct 
                         aiScene* aiImportFileExWithProperties(
    const char* pFile,
    unsigned int pFlags,
    
   struct 
            aiFileIO* pFS,
    const 
         struct 
                  aiPropertyStore* pProps);

__attribute__((visibility("default"))) 
          const 
                struct 
                         aiScene* aiImportFileFromMemory(
    const char* pBuffer,
    unsigned int pLength,
    unsigned int pFlags,
    const char* pHint);

__attribute__((visibility("default"))) 
          const 
                struct 
                         aiScene* aiImportFileFromMemoryWithProperties(
    const char* pBuffer,
    unsigned int pLength,
    unsigned int pFlags,
    const char* pHint,
    const 
         struct 
                  aiPropertyStore* pProps);

__attribute__((visibility("default"))) 
          const 
                struct 
                         aiScene* aiApplyPostProcessing(
    const 
         struct 
                  aiScene* pScene,
    unsigned int pFlags);

__attribute__((visibility("default"))) struct 
                   aiLogStream aiGetPredefinedLogStream(
    
   enum 
          aiDefaultLogStream pStreams,
    const char* file);

__attribute__((visibility("default"))) 
          void aiAttachLogStream(
    const 
         struct 
                  aiLogStream* stream);

__attribute__((visibility("default"))) 
          void aiEnableVerboseLogging(aiBool d);

__attribute__((visibility("default"))) enum 
                 aiReturn aiDetachLogStream(
    const 
         struct 
                  aiLogStream* stream);

__attribute__((visibility("default"))) 
          void aiDetachAllLogStreams(void);








__attribute__((visibility("default"))) 
          void aiReleaseImport(
    const 
         struct 
                  aiScene* pScene);

__attribute__((visibility("default"))) 
          const char* aiGetErrorString(void);

__attribute__((visibility("default"))) 
          aiBool aiIsExtensionSupported(
    const char* szExtension);

__attribute__((visibility("default"))) 
          void aiGetExtensionList(
    
   struct 
            aiString* szOut);







__attribute__((visibility("default"))) 
          void aiGetMemoryRequirements(
    const 
         struct 
                  aiScene* pIn,
    
   struct 
            aiMemoryInfo* in);

__attribute__((visibility("default"))) struct 
                   aiPropertyStore* aiCreatePropertyStore(void);






__attribute__((visibility("default"))) 
          void aiReleasePropertyStore(
                                      struct 
                                               aiPropertyStore* p);

__attribute__((visibility("default"))) 
          void aiSetImportPropertyInteger(
    
   struct 
            aiPropertyStore* store,
    const char* szName,
    int value);

__attribute__((visibility("default"))) 
          void aiSetImportPropertyFloat(
    
   struct 
            aiPropertyStore* store,
    const char* szName,
    ai_real value);

__attribute__((visibility("default"))) 
          void aiSetImportPropertyString(
    
   struct 
            aiPropertyStore* store,
    const char* szName,
    const 
         struct 
                  aiString* st);

__attribute__((visibility("default"))) 
          void aiSetImportPropertyMatrix(
    
   struct 
            aiPropertyStore* store,
    const char* szName,
    const 
         struct 
                  aiMatrix4x4* mat);








__attribute__((visibility("default"))) 
          void aiCreateQuaternionFromMatrix(
    
   struct 
            aiQuaternion* quat,
    const 
         struct 
                  aiMatrix3x3* mat);

__attribute__((visibility("default"))) 
          void aiDecomposeMatrix(
    const 
         struct 
                  aiMatrix4x4* mat,
    
   struct 
            aiVector3D* scaling,
    
   struct 
            aiQuaternion* rotation,
    
   struct 
            aiVector3D* position);






__attribute__((visibility("default"))) 
          void aiTransposeMatrix4(
    
   struct 
            aiMatrix4x4* mat);






__attribute__((visibility("default"))) 
          void aiTransposeMatrix3(
    
   struct 
            aiMatrix3x3* mat);







__attribute__((visibility("default"))) 
          void aiTransformVecByMatrix3(
    
   struct 
            aiVector3D* vec,
    const 
         struct 
                  aiMatrix3x3* mat);







__attribute__((visibility("default"))) 
          void aiTransformVecByMatrix4(
    
   struct 
            aiVector3D* vec,
    const 
         struct 
                  aiMatrix4x4* mat);







__attribute__((visibility("default"))) 
          void aiMultiplyMatrix4(
    
   struct 
            aiMatrix4x4* dst,
    const 
         struct 
                  aiMatrix4x4* src);







__attribute__((visibility("default"))) 
          void aiMultiplyMatrix3(
    
   struct 
            aiMatrix3x3* dst,
    const 
         struct 
                  aiMatrix3x3* src);






__attribute__((visibility("default"))) 
          void aiIdentityMatrix3(
    
   struct 
            aiMatrix3x3* mat);






__attribute__((visibility("default"))) 
          void aiIdentityMatrix4(
    
   struct 
            aiMatrix4x4* mat);






__attribute__((visibility("default"))) 
          size_t aiGetImportFormatCount(void);

__attribute__((visibility("default"))) 
          const 
                struct 
                         aiImporterDesc* aiGetImportFormatDescription( size_t pIndex);

__attribute__((visibility("default"))) 
          int aiVector2AreEqual(
    const 
         struct 
                  aiVector2D* a,
    const 
         struct 
                  aiVector2D* b);

__attribute__((visibility("default"))) 
          int aiVector2AreEqualEpsilon(
    const 
         struct 
                  aiVector2D* a,
    const 
         struct 
                  aiVector2D* b,
    const float epsilon);







__attribute__((visibility("default"))) 
          void aiVector2Add(
    
   struct 
            aiVector2D* dst,
    const 
         struct 
                  aiVector2D* src);







__attribute__((visibility("default"))) 
          void aiVector2Subtract(
    
   struct 
            aiVector2D* dst,
    const 
         struct 
                  aiVector2D* src);







__attribute__((visibility("default"))) 
          void aiVector2Scale(
    
   struct 
            aiVector2D* dst,
    const float s);








__attribute__((visibility("default"))) 
          void aiVector2SymMul(
    
   struct 
            aiVector2D* dst,
    const 
         struct 
                  aiVector2D* other);







__attribute__((visibility("default"))) 
          void aiVector2DivideByScalar(
    
   struct 
            aiVector2D* dst,
    const float s);








__attribute__((visibility("default"))) 
          void aiVector2DivideByVector(
    
   struct 
            aiVector2D* dst,
    
   struct 
            aiVector2D* v);






__attribute__((visibility("default"))) 
          float aiVector2Length(
    const 
         struct 
                  aiVector2D* v);






__attribute__((visibility("default"))) 
          float aiVector2SquareLength(
    const 
         struct 
                  aiVector2D* v);






__attribute__((visibility("default"))) 
          void aiVector2Negate(
    
   struct 
            aiVector2D* dst);








__attribute__((visibility("default"))) 
          float aiVector2DotProduct(
    const 
         struct 
                  aiVector2D* a,
    const 
         struct 
                  aiVector2D* b);






__attribute__((visibility("default"))) 
          void aiVector2Normalize(
    
   struct 
            aiVector2D* v);

__attribute__((visibility("default"))) 
          int aiVector3AreEqual(
    const 
         struct 
                  aiVector3D* a,
    const 
         struct 
                  aiVector3D* b);

__attribute__((visibility("default"))) 
          int aiVector3AreEqualEpsilon(
    const 
         struct 
                  aiVector3D* a,
    const 
         struct 
                  aiVector3D* b,
    const float epsilon);

__attribute__((visibility("default"))) 
          int aiVector3LessThan(
    const 
         struct 
                  aiVector3D* a,
    const 
         struct 
                  aiVector3D* b);







__attribute__((visibility("default"))) 
          void aiVector3Add(
    
   struct 
            aiVector3D* dst,
    const 
         struct 
                  aiVector3D* src);







__attribute__((visibility("default"))) 
          void aiVector3Subtract(
    
   struct 
            aiVector3D* dst,
    const 
         struct 
                  aiVector3D* src);







__attribute__((visibility("default"))) 
          void aiVector3Scale(
    
   struct 
            aiVector3D* dst,
    const float s);








__attribute__((visibility("default"))) 
          void aiVector3SymMul(
    
   struct 
            aiVector3D* dst,
    const 
         struct 
                  aiVector3D* other);







__attribute__((visibility("default"))) 
          void aiVector3DivideByScalar(
    
   struct 
            aiVector3D* dst,
    const float s);








__attribute__((visibility("default"))) 
          void aiVector3DivideByVector(
    
   struct 
            aiVector3D* dst,
    
   struct 
            aiVector3D* v);






__attribute__((visibility("default"))) 
          float aiVector3Length(
    const 
         struct 
                  aiVector3D* v);






__attribute__((visibility("default"))) 
          float aiVector3SquareLength(
    const 
         struct 
                  aiVector3D* v);






__attribute__((visibility("default"))) 
          void aiVector3Negate(
    
   struct 
            aiVector3D* dst);








__attribute__((visibility("default"))) 
          float aiVector3DotProduct(
    const 
         struct 
                  aiVector3D* a,
    const 
         struct 
                  aiVector3D* b);

__attribute__((visibility("default"))) 
          void aiVector3CrossProduct(
    
   struct 
            aiVector3D* dst,
    const 
         struct 
                  aiVector3D* a,
    const 
         struct 
                  aiVector3D* b);






__attribute__((visibility("default"))) 
          void aiVector3Normalize(
    
   struct 
            aiVector3D* v);






__attribute__((visibility("default"))) 
          void aiVector3NormalizeSafe(
    
   struct 
            aiVector3D* v);







__attribute__((visibility("default"))) 
          void aiVector3RotateByQuaternion(
    
   struct 
            aiVector3D* v,
    const 
         struct 
                  aiQuaternion* q);







__attribute__((visibility("default"))) 
          void aiMatrix3FromMatrix4(
    
   struct 
            aiMatrix3x3* dst,
    const 
         struct 
                  aiMatrix4x4* mat);







__attribute__((visibility("default"))) 
          void aiMatrix3FromQuaternion(
    
   struct 
            aiMatrix3x3* mat,
    const 
         struct 
                  aiQuaternion* q);

__attribute__((visibility("default"))) 
          int aiMatrix3AreEqual(
    const 
         struct 
                  aiMatrix3x3* a,
    const 
         struct 
                  aiMatrix3x3* b);

__attribute__((visibility("default"))) 
          int aiMatrix3AreEqualEpsilon(
    const 
         struct 
                  aiMatrix3x3* a,
    const 
         struct 
                  aiMatrix3x3* b,
    const float epsilon);






__attribute__((visibility("default"))) 
          void aiMatrix3Inverse(
    
   struct 
            aiMatrix3x3* mat);






__attribute__((visibility("default"))) 
          float aiMatrix3Determinant(
    const 
         struct 
                  aiMatrix3x3* mat);







__attribute__((visibility("default"))) 
          void aiMatrix3RotationZ(
    
   struct 
            aiMatrix3x3* mat,
    const float angle);








__attribute__((visibility("default"))) 
          void aiMatrix3FromRotationAroundAxis(
    
   struct 
            aiMatrix3x3* mat,
    const 
         struct 
                  aiVector3D* axis,
    const float angle);







__attribute__((visibility("default"))) 
          void aiMatrix3Translation(
    
   struct 
            aiMatrix3x3* mat,
    const 
         struct 
                  aiVector2D* translation);








__attribute__((visibility("default"))) 
          void aiMatrix3FromTo(
    
   struct 
            aiMatrix3x3* mat,
    const 
         struct 
                  aiVector3D* from,
    const 
         struct 
                  aiVector3D* to);







__attribute__((visibility("default"))) 
          void aiMatrix4FromMatrix3(
    
   struct 
            aiMatrix4x4* dst,
    const 
         struct 
                  aiMatrix3x3* mat);

__attribute__((visibility("default"))) 
          void aiMatrix4FromScalingQuaternionPosition(
    
   struct 
            aiMatrix4x4* mat,
    const 
         struct 
                  aiVector3D* scaling,
    const 
         struct 
                  aiQuaternion* rotation,
    const 
         struct 
                  aiVector3D* position);







__attribute__((visibility("default"))) 
          void aiMatrix4Add(
    
   struct 
            aiMatrix4x4* dst,
    const 
         struct 
                  aiMatrix4x4* src);

__attribute__((visibility("default"))) 
          int aiMatrix4AreEqual(
    const 
         struct 
                  aiMatrix4x4* a,
    const 
         struct 
                  aiMatrix4x4* b);

__attribute__((visibility("default"))) 
          int aiMatrix4AreEqualEpsilon(
    const 
         struct 
                  aiMatrix4x4* a,
    const 
         struct 
                  aiMatrix4x4* b,
    const float epsilon);






__attribute__((visibility("default"))) 
          void aiMatrix4Inverse(
    
   struct 
            aiMatrix4x4* mat);







__attribute__((visibility("default"))) 
          float aiMatrix4Determinant(
    const 
         struct 
                  aiMatrix4x4* mat);








__attribute__((visibility("default"))) 
          int aiMatrix4IsIdentity(
    const 
         struct 
                  aiMatrix4x4* mat);

__attribute__((visibility("default"))) 
          void aiMatrix4DecomposeIntoScalingEulerAnglesPosition(
    const 
         struct 
                  aiMatrix4x4* mat,
    
   struct 
            aiVector3D* scaling,
    
   struct 
            aiVector3D* rotation,
    
   struct 
            aiVector3D* position);

__attribute__((visibility("default"))) 
          void aiMatrix4DecomposeIntoScalingAxisAnglePosition(
    const 
         struct 
                  aiMatrix4x4* mat,
    
   struct 
            aiVector3D* scaling,
    
   struct 
            aiVector3D* axis,
    float* angle,
    
   struct 
            aiVector3D* position);

__attribute__((visibility("default"))) 
          void aiMatrix4DecomposeNoScaling(
    const 
         struct 
                  aiMatrix4x4* mat,
    
   struct 
            aiQuaternion* rotation,
    
   struct 
            aiVector3D* position);

__attribute__((visibility("default"))) 
          void aiMatrix4FromEulerAngles(
    
   struct 
            aiMatrix4x4* mat,
    float x, float y, float z);







__attribute__((visibility("default"))) 
          void aiMatrix4RotationX(
    
   struct 
            aiMatrix4x4* mat,
    const float angle);







__attribute__((visibility("default"))) 
          void aiMatrix4RotationY(
    
   struct 
            aiMatrix4x4* mat,
    const float angle);







__attribute__((visibility("default"))) 
          void aiMatrix4RotationZ(
    
   struct 
            aiMatrix4x4* mat,
    const float angle);








__attribute__((visibility("default"))) 
          void aiMatrix4FromRotationAroundAxis(
    
   struct 
            aiMatrix4x4* mat,
    const 
         struct 
                  aiVector3D* axis,
    const float angle);







__attribute__((visibility("default"))) 
          void aiMatrix4Translation(
    
   struct 
            aiMatrix4x4* mat,
    const 
         struct 
                  aiVector3D* translation);







__attribute__((visibility("default"))) 
          void aiMatrix4Scaling(
    
   struct 
            aiMatrix4x4* mat,
    const 
         struct 
                  aiVector3D* scaling);








__attribute__((visibility("default"))) 
          void aiMatrix4FromTo(
    
   struct 
            aiMatrix4x4* mat,
    const 
         struct 
                  aiVector3D* from,
    const 
         struct 
                  aiVector3D* to);

__attribute__((visibility("default"))) 
          void aiQuaternionFromEulerAngles(
    
   struct 
            aiQuaternion* q,
    float x, float y, float z);








__attribute__((visibility("default"))) 
          void aiQuaternionFromAxisAngle(
    
   struct 
            aiQuaternion* q,
    const 
         struct 
                  aiVector3D* axis,
    const float angle);








__attribute__((visibility("default"))) 
          void aiQuaternionFromNormalizedQuaternion(
    
   struct 
            aiQuaternion* q,
    const 
         struct 
                  aiVector3D* normalized);

__attribute__((visibility("default"))) 
          int aiQuaternionAreEqual(
    const 
         struct 
                  aiQuaternion* a,
    const 
         struct 
                  aiQuaternion* b);

__attribute__((visibility("default"))) 
          int aiQuaternionAreEqualEpsilon(
    const 
         struct 
                  aiQuaternion* a,
    const 
         struct 
                  aiQuaternion* b,
    const float epsilon);






__attribute__((visibility("default"))) 
          void aiQuaternionNormalize(
    
   struct 
            aiQuaternion* q);







__attribute__((visibility("default"))) 
          void aiQuaternionConjugate(
    
   struct 
            aiQuaternion* q);







__attribute__((visibility("default"))) 
          void aiQuaternionMultiply(
    
   struct 
            aiQuaternion* dst,
    const 
         struct 
                  aiQuaternion* q);

__attribute__((visibility("default"))) 
          void aiQuaternionInterpolate(
    
   struct 
            aiQuaternion* dst,
    const 
         struct 
                  aiQuaternion* start,
    const 
         struct 
                  aiQuaternion* end,
    const float factor);
