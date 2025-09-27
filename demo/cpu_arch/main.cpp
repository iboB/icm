// Copyright (c) Borislav Stanimirov
// SPDX-License-Identifier: MIT
//
#include <iostream>

#if defined(_MSC_VER) && !defined(__ARM_ARCH) && _WIN64
#   if !defined(__SSE__)
#       define __SSE__ 1
#   endif
#   if !defined(__SSE2__)
#       define __SSE2__ 1
#   endif
#endif

int main() {
#if defined(__SSE__)
    std::cout << "SSE is supported\n";
#endif

#if defined(__SSE2__)
    std::cout << "SSE2 is supported\n";
#endif

#if defined(__AVX__)
    std::cout << "AVX is supported\n";
#endif

#if defined(__AVX2__)
    std::cout << "AVX2 is supported\n";
#endif

#if defined(__AVX512F__)
    std::cout << "AVX-512F is supported\n";
#endif

    return 0;
}