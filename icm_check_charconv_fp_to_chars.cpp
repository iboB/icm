#include <charconv>
int main() {
    double d = 3.14;
    char out[25]; // max length of double
    auto result = std::to_chars(out, out + sizeof(out), d);
}
