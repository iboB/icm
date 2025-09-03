// Copyright (c) Borislav Stanimirov
// SPDX-License-Identifier: MIT
//
#include "lib.h"

accumulator accumulator_init_with(int init) {
    return (accumulator){init};
}

accumulator accumulator_init() {
    return accumulator_init_with(0);
}

void accumulator_acc(accumulator* acc, int value) {
    acc->sum += value;
}

int accumulator_sum(const accumulator* acc) {
    return acc->sum;
}