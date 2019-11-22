#pragma once

#include <drivers/vga.h>

#define KASSERT(expr) do { \
    if (!(expr)) { \
        vga_print_string("assertion failed:\n"); \
        vga_print_string(#expr); \
        vga_print_string("\n"); \
    } \
} while (0)
