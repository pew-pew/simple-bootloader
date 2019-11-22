#include <drivers/vga.h>
#include <cpu/interrupt.h>

#include <cpu/pic.h>
#include <kernel/port.h>

char digit_to_hex(int x) {
    return (x < 10 ? '0' + x : 'a' + x - 10);
}

void handler(Details* details) {
    uint8_t irq = details->number - IRQ0_offset; // TODO, WARNING

    if (irq != 0) {
        vga_print_hex(details->number);
        vga_print_string(" FROM INTERRUPT\n");
    }

    if (details->number == IRQ0_offset + 1) {
        uint8_t smt = port_byte_read(0x60);
        vga_print_hex(smt);
        vga_print_string("\n");
    }
    port_byte_write(PIC1_cmd, 1 << 5);
}
