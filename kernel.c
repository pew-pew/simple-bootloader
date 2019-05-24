int main() {
    char str[] = "HELLO";
    char* video = 0xb8000;

    for (int i = 0; i < (int)sizeof(str) - 1; i++) {
        video[i * 2] = str[i];
    }
}
