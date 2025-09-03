#include <array>
#include <intrin.h>
#include <cstdio>

const char* get_best_simd() {
    std::array<int, 4> cpui;
    __cpuidex(cpui.data(), 7, 0);
    if (cpui[1] & (1 << 16)) {
        return "AVX512";
    }

    cpui.fill(0);
    __cpuid(cpui.data(), 7);
    if (cpui[1] & (1 << 5)) {
        return "AVX2";
    }

    cpui.fill(0);
    __cpuid(cpui.data(), 1);
    if (cpui[2] & (1 << 28)) {
        return "AVX";
    }

    if (cpui[2] & (1 << 20)) {
        return "SSE4.2";
    }

    if (cpui[3] & (1 << 26)) {
        return "SSE2";
    }

    return "NONE";
}

int main() {
    printf(get_best_simd());
    return 0;
}
