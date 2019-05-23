gdt_start:
    gdt_null:
        times 4 db 0 ; empty entry

    gdt_code:
        %include "gdt/gdt_code_segment.asm"

    gdt_data:
        %include "gdt/gdt_data_segment.asm"
gdt_end:

gdt:
    dw (gdt_end - gdt_start) - 1
    dw gdt_start

CODE_SEG equ gdt_code - gdt_start
DATA_SEG equ gdt_data - gdt_start
