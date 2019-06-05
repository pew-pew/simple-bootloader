#include <cpu/idt.h>


IDT_descriptor idt[IDT_ENTRIES];

IDT_register idt_register = {
    .limit = sizeof(IDT_descriptor) * IDT_ENTRIES - 1,
    .base = (uint32_t)idt,
};

void init_idt() {
    asm("lidt (%0)" : : "r"(&idt_register));
}

void set_idt_gate(size_t index, uint32_t offset) {
    IDT_descriptor* id = &idt[index];
    id->offset_low = offset & ((1ull << 16) - 1);
    id->segment_selector = 0;
    id->zero = 0;
    id->low = 0;
    id->mid = 0b01111;
    id->DPL = 0;
    id->P = 1;
    id->offset_high = offset >> 16;
}
