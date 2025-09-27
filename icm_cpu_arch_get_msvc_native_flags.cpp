#include <array>
#include <intrin.h>
#include <cstdio>

using ar4 = std::array<int, 4>;

ar4 cpuid(int info) {
    ar4 cpui;
    __cpuid(cpui.data(), info);
    return cpui;
}

const char* get_best_simd() {
    ar4 i;
    __cpuidex(i.data(), 7, 0);
    if (i[1] & (1 << 16)) {
        return "AVX512";
    }

    i = cpuid(7);
    if (i[1] & (1 << 5)) {
        return "AVX2";
    }

    i = cpuid(1);
    if (i[2] & (1 << 28)) {
        return "AVX";
    }

    if (i[2] & (1 << 20)) {
        return "SSE4.2";
    }

    if (i[3] & (1 << 26)) {
        return "SSE2";
    }

    return "NONE";
}

int main() {
    printf(get_best_simd());
    return 0;
}
