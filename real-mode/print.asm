; char in al
print_char:
    push ax

    mov ah, 0x0e
    int 0x10

    pop ax
    ret

; pointer to string in ax
print_string:
    push ax
    push bx
    mov bx, ax

    print_string_loop:
        mov al, [bx]
        cmp al, 0
        je print_string_end

        call print_char

        inc bx
        jmp print_string_loop

    print_string_end:


    pop bx
    pop ax
    ret

; in al
print_hex_4b:
    push bx
    push ax

    mov bl, al

    shr al, 4
    call print_hex_digit

    mov al, bl
    and al, 0x0f
    call print_hex_digit

    pop ax
    pop bx

    ret

; in al
print_hex_digit:
    cmp al, 10
    
    jge big
        add al, '0'
        jmp fin

    big:
        add al, ('a' - 10)

    fin:
        call print_char

    ret

print_nl:
    push ax

    mov al, `\r`
    call print_char
    
    mov al, `\n`
    call print_char

    pop ax
    ret
