// Copyright (c) Borislav Stanimirov
// SPDX-License-Identifier: MIT
//
#include "../symbol_export.h"

#if C_LIB_SHARED
#   if BUILDING_C_LIB
#       define C_LIB_API SYMBOL_EXPORT
#   else
#       define C_LIB_API SYMBOL_IMPORT
#   endif
#else
#   define C_LIB_API
#endif

#if defined(__cplusplus)
extern "C" {
#endif

typedef struct accumulator {
    int sum;
} accumulator;

C_LIB_API accumulator accumulator_init();
C_LIB_API accumulator accumulator_init_with(int init);
C_LIB_API void accumulator_acc(accumulator* acc, int value);
C_LIB_API int accumulator_sum(const accumulator* acc);

#if defined(__cplusplus)
} // extern "C"
#endif
