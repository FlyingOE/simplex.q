// stdafx.h : include file for standard system include files,
// or project specific include files that are used frequently, but
// are changed infrequently
//

#pragma once

#include "targetver.h"

#define WIN32_LEAN_AND_MEAN             // Exclude rarely-used stuff from Windows headers
#define NOMINMAX
// Windows Header Files:
#include <windows.h>

//// kdb+
#define KXVER 3
#include <k.h>
#pragma comment(lib, "q.lib")

//// COIN-OR CLP
#include "ClpSimplex.hpp"
#pragma comment(lib, "libClp.lib")
#include "CoinBuild.hpp"
#pragma comment(lib, "libCoinUtils.lib")