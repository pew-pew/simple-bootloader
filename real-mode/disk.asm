; dh - # of sectors, dl - drive number
; es:bx - ptr to output buffer
disk_load:
    pusha

    push dx

    mov ah, 0x02
    mov al, dh
    mov cl, 0x02 ; first boot sector
    mov ch, 0x00
    mov dh, 0x00

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
    call print_string

    mov al, bl
    call print_hex_4b
    call print_nl

    jmp $ ; hang
    ret

sectors_err:
    mov ax, sectors_error_msg
    call print_string
    jmp $ ; hang
    ret

disk_error_msg:
    db `Disk read error, code:\r\n`, 0

sectors_error_msg:
    db `Unexpected number of sectors\r\n`, 0
