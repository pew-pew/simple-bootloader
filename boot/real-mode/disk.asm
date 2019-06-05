[bits 16]

; dh - # of sectors, dl - drive number
; es:bx - ptr to output buffer
disk_load:
    pusha

    push dx

    mov ah, 0x02
    mov al, dh ; number of sectors
    mov cl, 0x02 ; sector number
    mov ch, 0x00 ; track number
    mov dh, 0x00 ; head number (0-15)
    ; dl - drive number

    int 0x13
    jc disk_err

    pop dx

    ;   \/ how many read
    cmp al, dh
    jne sectors_err

    popa

    ret

    disk_err:
        mov bl, ah

        mov ax, disk_error_msg
        call real_print_string

        mov al, bl
        call real_print_hex_4b
        call real_print_nl

        jmp $ ; hang

    sectors_err:
        mov ax, sectors_error_msg
        call real_print_string
        jmp $ ; hang

disk_error_msg:
    db `Disk read error, code:\r\n`, 0

sectors_error_msg:
    db `Unexpected number of sectors\r\n`, 0
