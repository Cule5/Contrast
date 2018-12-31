#pragma once

#ifdef JACPP_EXPORTS
#define JACPP_API __declspec(dllexport)
#else
#define JACPP_API __declspec(dllimport)
#endif


extern "C" JACPP_API void MyProc2(unsigned char* tab, int width, int height, double contrastLevel);


