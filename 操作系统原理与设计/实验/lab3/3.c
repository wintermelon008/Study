#include <stdio.h>
#include <string.h>
#include <stdlib.h>
#include <unistd.h>
#include <sys/socket.h>
#include <netinet/in.h>
#include <arpa/inet.h>
#include <fcntl.h>
#include <errno.h>


// User struct
#define MAX_USERNAME_LEN 40
typedef struct User {
    int id; // the same as cfd
} User;

#define MAX_USERNUM 32
User users[MAX_USERNUM] = {};
int user_num = 0;


void send_to_all(User user, char* message, long length) {
    if (length <= 0)
        length = strlen(message);
    printf("A new message:\n%s\n", message);
    for (int i = 0; i < user_num; ++i) {
        if (users[i].id == user.id)   // Not self
            continue;

        long ret = 0;
            
        sendstart:
        ret = send(users[i].id, message, length, 0);
        if (ret < 0)
            break;
        if (ret < length) {
            message = message + ret;
            length = length - ret;
            goto sendstart;
        }
    }
}

#define MAX_RECV_SIZE 1000


int get_maxfd(fd_set clients, int maxfd) {
    int new_max = 0;
    for (int i = maxfd; i >= 0; --i) {
        if (i > new_max && FD_ISSET(i, &clients)) {
            new_max = i;
        }
    }
    return new_max;
}


int main(int argc, char **argv) {
    if (argc != 3) {
        printf("ERROR: Please input the correct net port\n");
        return -1;
    }

    const char *ip = argv[1];
    const short port = (short)atoi(argv[2]);

    struct sockaddr_in addr;
    memset(&addr, 0, sizeof(addr));  //每个字节都用0填充
    addr.sin_family = AF_INET;
    addr.sin_addr.s_addr = inet_addr(ip);
    addr.sin_port = htons(port);

    int fd;
    if ((fd = socket(AF_INET, SOCK_STREAM, 0)) == -1) {
        perror("socket");
        return 1;
    }
    fcntl(fd, F_SETFL, fcntl(fd, F_GETFL, 0) | O_NONBLOCK); 


    if (bind(fd, (struct sockaddr *)&addr, (socklen_t)sizeof(addr)) == -1) {
        perror("bind");
        return 1;
    }
    if (listen(fd, 32) == -1) {
        perror("listen");
        return 1;
    }


    fd_set clients, clients_bk;

    int max_id = fd;
    FD_ZERO(&clients);
    FD_ZERO(&clients_bk);
    FD_SET(fd, &clients_bk);

    while (1) {

        clients = clients_bk;
        max_id = get_maxfd(clients, max_id);


        int ret = select(max_id + 1, &clients, NULL, NULL, NULL);

        if (ret == -1) {
            perror("select");
            return -1;
        }
        else if (ret <= 0) {
            continue;
        }


        for (int i = 0; i <= max_id; ++i) {
            if (!FD_ISSET(i, &clients)) {
                continue;
            }
            if (i == fd) {

                int user_id = accept(fd, NULL, NULL);
                if (user_id == -1) {
                    perror("accept");
                    return -1;
                }
                fcntl(user_id, F_SETFL, fcntl(user_id, F_GETFL, 0) | O_NONBLOCK);
                if (user_id > max_id) {
                    max_id = user_id;
                }
                char buffer[30] = {};
                strcpy(buffer, "User[");
                char id[10] = {};
                sprintf(id, "%d", user_id);
                strcat(buffer, id); 
                strcat(buffer, "] has joined the room.\n");
                send_to_all(users[user_num], buffer, -1);
                users[user_num].id = user_id;

                FD_SET(user_id, &clients_bk);
                user_num++;
            }
            else {
                User user;
                for (int j = 0; j < user_num; ++j) {
                    if (users[j].id == i) {
                        user = users[j];
                        break;
                    }
                } 

                char buffer[1024] = {}, buffer1[1024] = {};

                long len = recv(user.id, buffer + strlen(buffer), MAX_RECV_SIZE, 0);
                long len1 = 0;


                Recv_start:
                if (len <= 0) {
                   for (int j = 0; j < user_num; ++j) {
                        // find which one left the room
                        if (users[j].id == user.id) {
                            users[j] = users[--user_num];
                            strcpy(buffer, "User[");
                            char id[10] = {};
                            sprintf(id, "%d", user.id);
                            strcat(buffer, id); 
                            strcat(buffer, "] has left the room.\n");
                            break;
                        }   
                    }
                    send_to_all(user, buffer, -1);
                    close(user.id);
                    FD_CLR(user.id, &clients_bk);
                    continue;
                }


                if (len == MAX_RECV_SIZE && buffer[MAX_RECV_SIZE - 1] != '\n') {   
                    len1 = recv(user.id, buffer1, MAX_RECV_SIZE, 0);
                }

                char *bufferbase = buffer;
                char *nextline;
                
                while((nextline = strchr(bufferbase, '\n')) != NULL) {
                    long sendlen = nextline - bufferbase + 1;
                    char info[1024] = {};
                    strcpy(info, "User[");
                    char id[10] = {};
                    sprintf(id, "%d", user.id);
                    strcat(info, id);
                    strcat(info, "]: ");
                    int info_len = strlen(info);
                    strcat(info, bufferbase);
                    send_to_all(user, info, sendlen + info_len);
                    bufferbase = nextline + 1;

                    if (bufferbase >= buffer + len - 1)
                        break;
                }
                if (bufferbase < buffer + len) {
                    send_to_all(user, bufferbase, buffer - bufferbase + len);
                }
                if (len == MAX_RECV_SIZE && buffer[MAX_RECV_SIZE - 1] != '\n') {
                    len = len1;
                    strcpy(buffer, buffer1);
                    goto Recv_start;
                }
            }
        }
    }
}