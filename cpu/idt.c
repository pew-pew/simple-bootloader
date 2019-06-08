#include <cpu/idt.h>


IDT_descriptor idt[IDT_ENTRIES];
IDT_register idt_register;

void init_idt() {
    idt_register.limit = sizeof(IDT_descriptor) * IDT_ENTRIES - 1;
    idt_register.base = (uint32_t)idt;
    asm("lidt (%0)" : : "r"(&idt_register));
}

void set_idt_gate(size_t index, uint32_t offset) {
    IDT_descriptor* id = &idt[index];

    id->offset_low = offset & ((1ull << 16) - 1);
    id->segment_selector = 0x08;
    id->zero = 0;
    id->flags = 0b01110;
    id->DPL = 0;
    id->P = 1;
    id->offset_high = offset >> 16;
}
