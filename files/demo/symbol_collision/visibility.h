#if defined _WIN32 || defined __CYGWIN__
    #ifdef COMPILE_LIBRARY
        #define DLL_MACRO __declspec(dllexport)
    #else
        #define DLL_MACRO __declspec(dllimport)
    #endif
    #define DLL_LOCAL
#else
    #if __GNUC__ >= 4
        #define DLL_MACRO __attribute__((visibility("default")))
        #define DLL_LOCAL __attribute__((visibility("hidden")))
    #else
        #define DLL_MACRO
        #define DLL_LOCAL
    #endif
#endif
