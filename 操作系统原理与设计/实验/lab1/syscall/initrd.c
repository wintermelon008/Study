#include <sys/stat.h>
#include <sys/types.h>
#include <string.h>
#include <stdio.h>
#include <unistd.h>
int main() {
    printf("Hello, Linux!\n");
    printf("This is a syscall test!\n");

    // For not enough buffer
    char buffer[128] = "test";
    // For enough buffer
    // char buffer[128] = "test for linux";
    
    int ret;
    printf("Syscalls test starts now!\n");
    ret = syscall(548, buffer, strlen(buffer) + 1);

    if (ret == -1) {
	printf("Buffer too short!\n");
    }
    else {
	printf("Done! %s\n", buffer);
    }
    while (1) {}
    return 0;
}
