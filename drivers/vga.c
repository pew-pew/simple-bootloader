#include <drivers/vga.h>

#include <kernel/port.h>
#include <kernel/utils.h>

#include <stddef.h>


#define VIDEO_ADDRESS 0xb8000
char* const video_address = (char*)VIDEO_ADDRESS;
uint16_t* const video_address16 = (uint16_t*)VIDEO_ADDRESS;

#define ROWS 25
#define COLS 80

#define WHITE_ON_BLACK 0x0f

#define REG_SCREEN_CTL 0x3d4
#define REG_SCREEN_DATA 0x3d5

int get_position() {
    port_byte_write(REG_SCREEN_CTL, 14);
    int pos_high = port_byte_read(REG_SCREEN_DATA);

    port_byte_write(REG_SCREEN_CTL, 15);
    int pos_low = port_byte_read(REG_SCREEN_DATA);

    int pos = (pos_high << 8) + pos_low;

    return pos;
}

void set_position(int pos) {
    int pos_high = pos >> 8;
    int pos_low = pos & 0xff;

    port_byte_write(REG_SCREEN_CTL, 14);
    port_byte_write(REG_SCREEN_DATA, pos_high);
    port_byte_write(REG_SCREEN_CTL, 15);
    port_byte_write(REG_SCREEN_DATA, pos_low);
}

void shiftForward(int offset, uint16_t filler) {
    memory_copy((uint8_t*)video_address + offset * 2, (uint8_t*)video_address,
            (ROWS * COLS - offset) * 2);

    for (int i = 0; i < offset; i++) {
        video_address16[i] = filler;
    }
}

void shiftBackward(int offset, uint16_t filler) {
    memory_copy((uint8_t*)video_address, (uint8_t*)video_address + offset * 2,
            (ROWS * COLS - offset) * 2);

    for (int i = ROWS * COLS - offset; i < ROWS * COLS; i++) {
        video_address16[i] = filler;
    }
}

int divide_floor(int numenator, int denumenator) {
    int quot = numenator / denumenator;
    if (numenator * denumenator < 0 && numenator % denumenator != 0) {
        quot -= 1;
    }
    return quot;
}

int handle_scrolling(int pos) {
    int row = divide_floor(pos, COLS);
    uint16_t filler = (WHITE_ON_BLACK << 8) + ' ';
    if (row < 0) {
        int exceed = -row * COLS;
        pos += exceed;
        shiftForward(exceed, filler);
    } else if (row >= ROWS) {
        int exceed = (row - ROWS + 1) * COLS;
        pos -= exceed;
        shiftBackward(exceed, filler);
    }
    return pos;
}

void printChar(char c) {
    int pos = get_position();

    if (c == '\n') {
        int row = pos / COLS;
        pos = (row + 1) * COLS;
    } else {
        video_address[pos * 2] = c;
        video_address[pos * 2 + 1] = WHITE_ON_BLACK;
        pos++;
    }

    pos = handle_scrolling(pos);
    set_position(pos);
}

void vga_print_string(char *str) {
    while (*str != '\0') {
        printChar(*str);
        str++;
    }
}

void vga_clear_screen() {
    for (int pos = 0; pos < ROWS * COLS; pos++) {
        video_address[pos * 2] = ' ';
    }

    set_position(0);
}
