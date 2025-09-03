// Copyright (c) Borislav Stanimirov
// SPDX-License-Identifier: MIT
//
#include "lib.hpp"

Accumulator::Accumulator(int init) : m_sum(init) {}

void Accumulator::acc(int v) { m_sum += v; }

int Accumulator::sum() const { return m_sum; }
