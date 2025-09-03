// Copyright (c) Borislav Stanimirov
// SPDX-License-Identifier: MIT
//
#pragma once
#include "../symbol_export.h"

#if CPP_LIB_SHARED
#   if BUILDING_CPP_LIB
#       define CPP_LIB_API SYMBOL_EXPORT
#   else
#       define CPP_LIB_API SYMBOL_IMPORT
#   endif
#else
#   define CPP_LIB_API
#endif

class CPP_LIB_API Accumulator {
    int m_sum;
public:
    explicit Accumulator(int init = 0);

    void acc(int v);

    int sum() const;
};
