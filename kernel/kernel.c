#include <stddef.h>
#include <stdint.h>

#include <drivers/vga.h>


char hex_digit(uint8_t half) {
    return (half < 10 ? '0' + half : 'a' + half - 10);
}

void write_hex(char* out, uint8_t x) {
    out[0] = hex_digit((x >> 4));
    out[1] = hex_digit(x & 0xf);
}

void sleep() {
    int x = 0;
    for (int j = 0; j < 300000; j++) {
        x++;
    }
}

void main() {
    clearScreen();
    printString("Hello!\nWorld!");
    return;
}
