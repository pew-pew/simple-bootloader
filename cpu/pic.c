#include <cpu/pic.h>
#include <kernel/port.h>
#include <kernel/assert.h>

void init_pic(uint8_t irq0_offset, uint8_t irq8_offset) {
    KASSERT(irq0_offset % 8 == 0 && irq8_offset % 8 == 0);

    // TODO?: io_wait()

    // save IMRs
    uint8_t pic1_imr = port_byte_read(PIC1_data);
    uint8_t pic2_imr = port_byte_read(PIC2_data);
    
    // icw 1
    port_byte_write(PIC1_cmd, 0x11);
    port_byte_write(PIC2_cmd, 0x11);

    // icw 2
    port_byte_write(PIC1_data, irq0_offset);
    port_byte_write(PIC2_data, irq8_offset);

    // icw 3
    port_byte_write(PIC1_data, 1 << 2);
    port_byte_write(PIC2_data, 2);

    // icw 4
    port_byte_write(PIC1_data, 1);
    port_byte_write(PIC2_data, 1);

    // restore IMRs
    port_byte_write(PIC1_data, pic1_imr);
    port_byte_write(PIC2_data, pic2_imr);
}
