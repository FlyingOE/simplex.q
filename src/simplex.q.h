// The following ifdef block is the standard way of creating macros which make exporting 
// from a DLL simpler. All files within this DLL are compiled with the SIMPLEXQ_EXPORTS
// symbol defined on the command line. This symbol should not be defined on any project
// that uses this DLL. This way any other project whose source files include this file see 
// SIMPLEXQ_API functions as being imported from a DLL, whereas this DLL sees symbols
// defined with this macro as being exported.
#ifdef SIMPLEXQ_EXPORTS
#define SIMPLEXQ_API __declspec(dllexport)
#else
#define SIMPLEXQ_API __declspec(dllimport)
#endif

// kdb+ 32-bit API
#ifdef WIN32
#define K_DECL	_cdecl
#else
#define K_DECL
#endif

#ifdef __cplusplus
extern "C" {
#endif

	SIMPLEXQ_API K K_DECL version(K/*NOTE: at least one argument required by `2:'*/);

	SIMPLEXQ_API K K_DECL solveCpp(
		K maximize,		//1h
		K objective,	//9h
		K bounds,		//0h|101h ((lb0;ub0);(lb1;ub1);...) (defalut to (0 0wf) for all variables)
		K constraints	//98h ([]coeffs:"F"; lb:"f"; ub:"f")
		);

#ifdef __cplusplus
}//extern "C"
#endif