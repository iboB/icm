// Copyright (c) Borislav Stanimirov
// SPDX-License-Identifier: MIT
//
#include <iostream>
#include "cpp-lib/lib.hpp"
#include "c-lib/lib.h"

int main() {
    Accumulator cppa(10);
    cppa.acc(5);
    cppa.acc(3);
    cppa.acc(7);
    cppa.acc(17);
    std::cout << "Sum: " << cppa.sum() << std::endl;

    auto ca = accumulator_init_with(8);
    accumulator_acc(&ca, 15);
    accumulator_acc(&ca, 6);
    accumulator_acc(&ca, 4);
    std::cout << "Sum: " << accumulator_sum(&ca) << std::endl;
}