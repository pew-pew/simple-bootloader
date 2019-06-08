#include <drivers/vga.h>
#include <cpu/interrupt.h>

char digit_to_hex(int x) {
    return (x < 10 ? '0' + x : 'a' + x - 10);
}

void handler(Details* details) {
    char s[] = "__ FROM INTERRUPT\n";
    s[0] = digit_to_hex(details->number >> 4);
    s[1] = digit_to_hex(details->number & 0xf);
    vga_print_string(s);
}
