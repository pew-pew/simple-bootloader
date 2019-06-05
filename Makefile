BIN_ROOT = "cross-compiler/i386elfgcc/bin"
CC = $(BIN_ROOT)/i386-elf-gcc
LD = $(BIN_ROOT)/i386-elf-ld
#GDB = $(BIN_ROOT)/i386-elf-gdb
GDB = gdb

CC_FLAGS = -I. -g -ffreestanding -fno-asynchronous-unwind-tables

DST = build

KERNEL_OFFSET = 0x1000


.PHONY: run
run: build/os_image.bin
	qemu-system-i386 -drive format=raw,if=ide,file=$<

.PHONY: debug
debug: build/os_image.bin build/kernel.elf
	qemu-system-i386 -drive format=raw,if=ide,file=$< -s -S &
	sleep 1
	$(GDB) \
		-ex "symbol-file build/kernel.elf" \
		-ex "break main" \
		-ex "target remote localhost:1234" \
		-ex "continue" \
		-ex "layout src" \
		-ex "focus cmd"


# ======
# Kernel

C_SOURCES = $(wildcard kernel/*.c) $(wildcard drivers/*.c) $(wildcard cpu/*.c)
C_HEADERS = $(wildcard kernel/*.c) $(wildcard drivers/*.c) $(wildcard cpu/*.h)
C_OBJ = $(addprefix build/, $(C_SOURCES:.c=.o))

build/%.o: %.c $(C_HEADERS)
	@mkdir -p build/kernel
	@mkdir -p build/drivers
	@mkdir -p build/cpu
	$(CC) $(CC_FLAGS) $< -c -o $@

build/kernel/kernel_entry.o: kernel/kernel_entry.asm
	@mkdir -p build/kernel
	@mkdir -p build/drivers
	@mkdir -p build/cpu
	nasm -f elf $^ -o $@

build/kernel.bin: build/kernel/kernel_entry.o $(C_OBJ)
	$(LD) --oformat binary -Ttext $(KERNEL_OFFSET) $^ -o $@

build/kernel.elf: build/kernel/kernel_entry.o $(C_OBJ)
	$(LD) -Ttext $(KERNEL_OFFSET) $^ -o $@

# ===========
# Boot sector

BOOT_SOURCES = $(wildcard boot/*.asm) \
			   $(wildcard boot/real-mode/*.asm) \
			   $(wildcard boot/gdt/*.asm)

build/boot_sector.bin: boot/boot_sector.asm $(BOOT_SOURCES)
	nasm -f bin $< -o $@


# ========
# OS Image

build/os_image.bin: build/boot_sector.bin build/kernel.bin
	cat $^ > $@
	truncate $@ -s $$((512 * 20))
	cp $@ build/os_image.img # haha
