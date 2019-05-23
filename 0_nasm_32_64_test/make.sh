set -euxo pipefail


nasm -f bin sample.asm -o sample.bin

objdump -D -m i386 -M addr16,data16 -b binary sample.bin
