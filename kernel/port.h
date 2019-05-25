#pragma once

#include <stdint.h>

uint8_t port_byte_read(uint16_t port);

void port_byte_write(uint16_t port, uint8_t value);

uint16_t port_word_read(uint16_t port);

void port_word_write(uint16_t port, uint16_t value);
