#pragma once

#include <stdint.h>

enum {
    PIC1_cmd = 0x20,
    PIC1_data = 0x21,
    PIC2_cmd = 0xa0,
    PIC2_data = 0xa1
};

enum {
    IRQ0_offset = 0xa0,
    IRQ8_offset = 0xb0
};

void init_pic(uint8_t irq0_offset, uint8_t irq8_offset);
