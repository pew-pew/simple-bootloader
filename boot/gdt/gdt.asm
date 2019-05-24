gdt_start:
    gdt_null:
        times 8 db 0 ; empty entry

    gdt_code:
        %include "boot/gdt/gdt_code_segment.asm"

    gdt_data:
        %include "boot/gdt/gdt_data_segment.asm"
gdt_end:

gdt:
    db (gdt_end - gdt_start) - 1
    db 0
    dd gdt_start

CODE_SEG equ gdt_code - gdt_start
DATA_SEG equ gdt_data - gdt_start
