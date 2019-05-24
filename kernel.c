int main() {
    char* video = 0xb8000;
    for (int i = 0; i < 1000; i++) {
        video[i] = (char)i;
    }
}
