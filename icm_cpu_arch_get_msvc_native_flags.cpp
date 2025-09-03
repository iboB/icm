#include <array>
#include <intrin.h>
#include <cstdio>

int main() {
    std::array<int, 4> cpui;
    __cpuidex(cpui.data(), 7, 0);
    if (cpui[1] & (1 << 16)) {
        printf("AVX512");
        return 0;
    }

    cpui.fill(0);
    __cpuid(cpui.data(), 7);
    if (cpui[1] & (1 << 5)) {
        printf("AVX2");
        return 0;
    }

    cpui.fill(0);
    __cpuid(cpui.data(), 1);
    if (cpui[2] & (1 << 28)) {
        printf("AVX");
        return 0;
    }

    if (cpui[3] & (1 << 26)) {
        printf("SSE2");
        return 0;
    }

    printf("nope");

    return 0;
}
