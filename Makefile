BIN_ROOT := "cross-compiler/i386elfgcc/bin"
CC := $(BIN_ROOT)/i386-elf-gcc
LD := $(BIN_ROOT)/i386-elf-ld
#GDB := $(BIN_ROOT)/i386-elf-gdb
GDB := gdb

CC_FLAGS := -I. -g -ffreestanding -fno-asynchronous-unwind-tables -mno-red-zone

DST := build

KERNEL_OFFSET := 0x1000


.PHONY: build
build: build/os_image.bin

.PHONY: run
run: build/os_image.bin
	qemu-system-i386 -drive format=raw,if=ide,file=$< -d guest_errors

.PHONY: debug
debug: build/os_image.bin build/kernel.elf
	xfce4-terminal --command $(GDB)
	qemu-system-i386 -drive format=raw,if=ide,file=$< \
		-monitor telnet:127.0.0.1:12345,server,nowait \
		-s -S \
		-d guest_errors

# ======
# Kernel

C_SOURCES   := $(wildcard kernel/*.c) $(wildcard drivers/*.c) $(wildcard cpu/*.c)
C_HEADERS   := $(wildcard kernel/*.h) $(wildcard drivers/*.h) $(wildcard cpu/*.h)
ASM_SOURCES := $(wildcard kernel/*.asm) $(wildcard drivers/*.asm) $(wildcard cpu/*.asm)
OBJ := $(addprefix build/, $(C_SOURCES:.c=.o)) $(addprefix build/, $(ASM_SOURCES:.asm=.o))

.PHONY: hello
hello:
	@echo $(OBJ)


BUILD_DIRS := build/kernel build/drivers build/cpu
$(BUILD_DIRS):
	mkdir -p $@

build/%.o: %.c $(C_HEADERS) | $(BUILD_DIRS)
	$(CC) $(CC_FLAGS) $< -c -o $@

build/%.o: %.asm $(C_HEADERS) | $(BUILD_DIRS)
	nasm $< -f elf -o $@

build/kernel.bin: build/kernel/kernel_entry.o $(OBJ)
	$(LD) --oformat binary -Ttext $(KERNEL_OFFSET) $^ -o $@

build/kernel.elf: build/kernel/kernel_entry.o $(OBJ)
	$(LD) -Ttext $(KERNEL_OFFSET) $^ -o $@


# ===========
# Boot sector

BOOT_SOURCES := $(wildcard boot/*.asm) \
			    $(wildcard boot/real-mode/*.asm) \
			    $(wildcard boot/gdt/*.asm)

build/boot_sector.bin: boot/boot_sector.asm $(BOOT_SOURCES) | $(BUILD_DIRS)
	nasm -f bin $< -o $@


# ========
# OS Image

build/os_image.bin: build/boot_sector.bin build/kernel.bin
	cat $^ > $@
	truncate $@ -s $$((512 + 512 * 80))
	cp $@ build/os_image.img # haha
