#pragma once

#include <stdint.h>
#include <stddef.h>

typedef struct __attribute__((packed)) IDT_register {
    uint16_t limit;
    uint32_t base;
} IDT_register;

typedef struct __attribute__((packed)) IDT_descriptor {
    uint16_t offset_low;
    uint16_t segment_selector;

    uint8_t zero : 8;
    uint16_t flags : 5;
    uint16_t DPL : 2;
    uint16_t P : 1;

    uint16_t offset_high;
} IDT_descriptor;

enum {
    IDT_ENTRIES = 256
};

void init_idt();
void set_idt_gate(size_t index, uint32_t offset);
