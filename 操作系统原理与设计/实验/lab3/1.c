#include <stdio.h>
#include <string.h>
#include <stdlib.h>
#include <unistd.h>
#include <sys/socket.h>
#include <netinet/in.h>
#include <pthread.h>

#define MAX_RECV_SIZE 1000

struct Pipe {
    int fd_send;
    int fd_recv;
    int id;
};

void *handle_chat(void *data) {
    struct Pipe *pipe = (struct Pipe *)data;
    char buffer[1024] = " ", buffer1[1024] = " ";
 
    char id = pipe->id + '0';
    
    long len, len1;

    char id_buf[20] = "Your id is: 0\n";
    id_buf[12] = id;
    send(pipe->fd_send, id_buf, 20, 0);

    while (1) {
        len = recv(pipe->fd_send, buffer, MAX_RECV_SIZE, 0);
        if (len <= 0) break;
        Recv_start:

        if (len == MAX_RECV_SIZE && buffer[MAX_RECV_SIZE - 1] != '\n') {   
            len1 = recv(pipe->fd_send, buffer1, MAX_RECV_SIZE, 0);
        }
    
        buffer[MAX_RECV_SIZE] = '\n';
        buffer[MAX_RECV_SIZE + 1] = '\0'; 

        char *bufferbase = buffer;
        char *nextline;
        
        while((nextline = strchr(bufferbase, '\n')) != NULL) {
            long sendlen = nextline - bufferbase;
            char buf_head[1024] = "[0]: ";
            buf_head[1] = id;
            strncat(buf_head, bufferbase, 1000);

            long ret = 0, length = sendlen + 6;
            char *buffer_head = buf_head;

            sendstart:
            ret = send(pipe->fd_recv, buffer_head, length, 0);
            if (ret < length) {
                buffer_head = buffer_head + ret;
                length = length - ret;
                goto sendstart;
            }

            bufferbase = nextline + 1;

            if (bufferbase >= buffer + len)
                break;
        }

        if (len == MAX_RECV_SIZE && buffer[MAX_RECV_SIZE - 1] != '\n') {
            len = len1;
            strcpy(buffer, buffer1);
            goto Recv_start;
        }
    
    }
    return NULL;
}

int main(int argc, char **argv) {
    int port = atoi(argv[1]);   // Transfer string to number

    //创建套接字
    int fd;
    if ((fd = socket(AF_INET, SOCK_STREAM, 0)) == 0) {
        perror("socket");
        return 1;
    }


    //将套接字和IP、端口绑定
    struct sockaddr_in addr;
    memset(&addr, 0, sizeof(addr));  //每个字节都用0填充

    addr.sin_family = AF_INET;
    addr.sin_addr.s_addr = INADDR_ANY;
    addr.sin_port = htons(port);
    // socklen_t addr_len = sizeof(addr);
    if (bind(fd, (struct sockaddr *)&addr, sizeof(addr))) {
        perror("bind");
        return 1;
    }
    //进入监听状态，等待用户发起请求
    if (listen(fd, 2)) {
        perror("listen");
        return 1;
    }
    
    //printf("Test: 0\n");
    int fd1 = accept(fd, NULL, NULL);
    // 等待nc的接入
    //printf("Test: 0.1\n");
    int fd2 = accept(fd, NULL, NULL);
    //printf("Test: 0.2\n");
    if (fd1 == -1 || fd2 == -1) {
        perror("accept");
        return 1;
    }

    pthread_t thread1, thread2;
    struct Pipe pipe1;
    struct Pipe pipe2;
    pipe1.fd_send = fd1;
    pipe1.fd_recv = fd2;
    pipe1.id = 1;
    pipe2.fd_send = fd2;
    pipe2.fd_recv = fd1;
    pipe2.id = 2;
   
    pthread_create(&thread1, NULL, handle_chat, (void *)&pipe1);
    pthread_create(&thread2, NULL, handle_chat, (void *)&pipe2);
   // printf("Test: 1\n");
    pthread_join(thread1, NULL);
   // printf("Test: 2\n");
    pthread_join(thread2, NULL);
    //printf("Test: 3\n");

    //printf("The main function ends.\n");
    return 0;
}

