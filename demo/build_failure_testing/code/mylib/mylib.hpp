// Copyright (c) Borislav Stanimirov
// SPDX-License-Identifier: MIT
//
#pragma once
#include <type_traits>

namespace mylib
{

template <typename A, typename B>
auto add(A a, B b)
{
    static_assert(std::is_integral_v<A> && std::is_integral_v<B>, "add: values must be integral");
    return a + b;
}

template <typename A, typename B>
auto mul(A a, B b)
{
    static_assert(std::is_integral_v<A> && std::is_integral_v<B>, "mul: values must be integral");
    return a * b;
}

}
