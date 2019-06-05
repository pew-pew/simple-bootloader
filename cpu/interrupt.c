#include <drivers/vga.h>

void handler() {
    char s[] = "FROM INTERRUPT\n";
    printString(s);
}
