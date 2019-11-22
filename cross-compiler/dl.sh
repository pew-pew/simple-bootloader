# -e - fail if exit code != 0 (if not before ||, etc...)
# -u - error on undefined variables
# -x - print executed commands
# -o pipefail - exit code of pipe ...
set -euxo pipefail

binutils_url="https://ftpmirror.gnu.org/gnu/binutils/binutils-2.32.tar.gz"

if [[ ! -f "binutils-2.32.tar.gz" ]]; then
    curl -L $binutils_url -o "binutils-2.32.tar.gz"
fi

if [[ ! -d "binutils-2.32" ]]; then
    tar xfz "binutils-2.32.tar.gz"
fi


gcc_url="https://ftpmirror.gnu.org/gnu/gcc/gcc-8.3.0/gcc-8.3.0.tar.gz"

if [[ ! -f "gcc-8.3.0.tar.gz" ]]; then
    curl -L $gcc_url -o "gcc-8.3.0.tar.gz"
fi

if [[ ! -d "gcc-8.3.0" ]]; then
    tar xfz "gcc-8.3.0.tar.gz"
fi


gdb_url="https://ftpmirror.gnu.org/gnu/gdb/gdb-8.2.1.tar.gz"

if [[ ! -f "gdb-8.2.1.tar.gz" ]]; then
    curl -L $gdb_url -o "gdb-8.2.1.tar.gz"
fi

if [[ ! -d "gdb-8.2.1" ]]; then
    tar xfz "gdb-8.2.1.tar.gz"
fi
