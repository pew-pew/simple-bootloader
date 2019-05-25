#include <kernel/utils.h>

void memory_copy(uint8_t *dst, const uint8_t *src, size_t n) {
    if (dst < src) {
        for (size_t i = 0; i < n; i++) {
            dst[i] = src[i];
        }
    } else {
        for (size_t i = n - 1; i != (size_t)-1; i--) {
            dst[i] = src[i];
        }
    }
}
