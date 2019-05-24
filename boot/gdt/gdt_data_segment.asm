dw 0xffff ; limit low 16 bits
dw 0 ; base low 16 bits
db 0 ; base mid 8 bits

;     Present
;     : Privilege
;     : :  Descr type (1 - code/data)
;     : :  : Executable
;     : :  : : Direction
;     : :  : : : R(code)/W(data)
;     : :  : : : : Access bit
;     : :  : : : : :
db 0b_1_00_1_0_0_1_0

;     Granulariry (limit *= 4kb)
;     : Size (32 bit protected mode)
;     : : Some type-depentent attrubutes?
;     : : :  :limit high 4 bits:
db 0b_1_1_00__1111
db 0 ; base high 8 bits
