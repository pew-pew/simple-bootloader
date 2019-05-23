set -euxo pipefail


nasm -f bin boot_sector.asm -g -o boot_sector.img

objdump -D -m i386 -M addr16,data16 -b binary boot_sector.img

qemu-system-x86_64 -drive format=raw,if=floppy,file=boot_sector.img
