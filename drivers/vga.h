#pragma once

#include <stdint.h>

void vga_print_string(char *str);
void vga_clear_screen();
void vga_print_hex(uint8_t num);
