#include <stddef.h>
#include <stdint.h>

#include <drivers/vga.h>
#include <cpu/raw_interrupt_handler.h>
#include <cpu/idt.h>


char hex_digit(uint8_t half) {
    return (half < 10 ? '0' + half : 'a' + half - 10);
}

void write_hex(char* out, uint8_t x) {
    out[0] = hex_digit((x >> 4));
    out[1] = hex_digit(x & 0xf);
}

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

    asm("int $240");

    /*
    for (int i = 0; i < 25; i++) {
        vga_print_string("Hello!\n");
        sleep();
    }
    */
    return;
}
