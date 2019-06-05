[bits 16]

; char in al
real_print_char:
    pusha

    mov ah, 0x0e
    int 0x10

    popa
    ret

; pointer to string in ax
real_print_string:
    push ax
    push bx
    mov bx, ax

    real_print_string_loop:
        mov al, [bx]
        cmp al, 0
        je real_print_string_end

        call real_print_char

        inc bx
        jmp real_print_string_loop

    real_print_string_end:


    pop bx
    pop ax
    ret

; in al
real_print_hex_4b:
    push bx
    push ax

    mov bl, al

    shr al, 4
    call real_print_hex_digit

    mov al, bl
    and al, 0x0f
    call real_print_hex_digit

    pop ax
    pop bx

    ret

; in al
real_print_hex_digit:
    cmp al, 10

    jge big
        add al, '0'
        jmp fin

    big:
        add al, ('a' - 10)

    fin:
        call real_print_char

    ret

real_print_nl:
    push ax

    mov al, `\r`
    call real_print_char

    mov al, `\n`
    call real_print_char

    pop ax
    ret
