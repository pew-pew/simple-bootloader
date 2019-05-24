BIN_ROOT = "cross-compiler/i386elfgcc/bin"
CC = $(BIN_ROOT)/i386-elf-gcc
LD = $(BIN_ROOT)/i386-elf-ld
#GDB = $(BIN_ROOT)/i386-elf-gdb
GDB = gdb

CC_FLAGS = -g -ffreestanding -fno-asynchronous-unwind-tables

DST = build

KERNEL_OFFSET = 0x1000


.PHONY: run
run: build/os_image.bin
	qemu-system-x86_64 -drive format=raw,if=ide,file=$<

#.PHONY: debug
#debug: build/os_image.bin build/kernel.elf
#	qemu-system-x86_64 -drive format=raw,if=ide,file=$< -s -S &
#	sleep 1
#	$(GDB) \
#		-ex "symbol-file build/kernel.elf" \
#		-ex "break main" \
#		-ex "target remote localhost:1234" \
#		-ex "continue" \
#		-ex "layout src"
#

# ======
# Kernel

C_SOURCES = $(wildcard kernel/*.c) $(wildcard drivers/*.c)
C_HEADERS = $(wildcard kernel/*.c) $(wildcard drivers/*.c)
C_OBJ = $(addprefix build/, $(C_SOURCES:.c=.o))

build/%.o: %.c $(C_HEADERS)
	mkdir -p build/kernel
	$(CC) $(CC_FLAGS) $< -c -o $@

build/kernel/kernel_entry.o: kernel/kernel_entry.asm
	mkdir -p build/kernel
	nasm -f elf $^ -o $@

build/kernel.bin: build/kernel/kernel_entry.o $(C_OBJ)
	$(LD) --oformat binary -Ttext $(KERNEL_OFFSET) $^ -o $@

build/kernel.elf: build/kernel_entry.o build/kernel.o
	$(LD) -Ttext $(KERNEL_OFFSET) $^ -o $@

# ===========
# Boot sector

build/boot_sector.bin: boot/boot_sector.asm
	nasm -f bin $^ -o $@


# ========
# OS Image

build/os_image.bin: build/boot_sector.bin build/kernel.bin
	cat $^ > $@
