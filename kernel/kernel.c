#include <stddef.h>
#include <stdint.h>

#include <drivers/vga.h>
#include <cpu/raw_interrupt_handler.h>
#include <cpu/idt.h>

#include <kernel/port.h>
#include <cpu/pic.h>

void sleep() {
    int x = 0;
    for (int j = 0; j < 30000000; j++) {
        x++;
    }
}

void kernel_main() {
    for (int i = 0; i < IDT_ENTRIES; i++) {
        set_idt_gate(i, raw_interrupt_table[i]);
    }

    init_idt();

    vga_clear_screen();
    vga_print_string("Hello!\nWorld!\n");

    uint8_t *addr = 0xfffff00;
    vga_print_hex(*addr);
    *addr = 0xab;
    vga_print_hex(*addr);

    /*
    asm("sti");
    init_pic(IRQ0_offset, IRQ8_offset);

    port_byte_write(PIC2_data, 0);
    port_byte_write(PIC1_data, 0);

    port_word_write(0x604, 0x2000);

    uint8_t imr = port_byte_read(PIC2_data);
    imr = port_byte_read(0xabcd);
    vga_print_hex(imr);
    vga_print_string(" = imr\n");
    */

    return;
}
