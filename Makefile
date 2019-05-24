CC = i386-elf-gcc
LD = i386-elf-ld
CC_FLAGS = -ffreestanding -fno-asynchronous-unwind-tables

KERNEL_OFFSET = 0x1000

DST = build

.PHONY: run
run: build/os_image.bin
	qemu-system-x86_64 -drive format=raw,if=ide,file=$<

build/kernel.o: kernel.c
	$(CC) $(CC_FLAGS) $^ -c -o $@

build/kernel_entry.o: kernel_entry.asm
	nasm -f elf $^ -o $@

build/kernel.bin: build/kernel_entry.o build/kernel.o
	$(LD) $^ --oformat binary -Ttext $(KERNEL_OFFSET) -o $@

build/boot_sector.bin: boot/boot_sector.asm
	nasm -f bin $^ -o $@

build/os_image.bin: build/boot_sector.bin build/kernel.bin
	cat $^ > $@