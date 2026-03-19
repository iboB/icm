#include <print>
#include <limits>
#include <cstdint>

int main() {
    int x = std::numeric_limits<int64_t>::max();
    std::print("Max int64 truncated to int: {}\n", x);
    return 0;
}
