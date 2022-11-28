// Copyright (c) Borislav Stanimirov
// SPDX-License-Identifier: MIT
//
#include <mylib/mylib.hpp>
#include <cassert>

int main()
{
    assert(mylib::add(1, 2) == 3);
    auto sum = mylib::add(1ll, 2u);
    assert(sum == 3);
    static_assert(std::is_same_v<decltype(sum), long long>);

    assert(mylib::mul(2, 3) == 6);
    auto prod = mylib::mul(1ll, 2u);
    assert(prod == 2);
    static_assert(std::is_same_v<decltype(prod), long long>);

    return 0;
}
