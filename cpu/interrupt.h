#pragma once

#include <stdint.h>

typedef struct {
    uint32_t number;
    uint32_t error;
} Details;

void handler(Details* details);
