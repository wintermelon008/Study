#include <stdio.h>
#include <string.h>
#include <stdlib.h>
#include <unistd.h>
#include <sys/socket.h>
#include <netinet/in.h>
#include <pthread.h>
#include <arpa/inet.h>


// User struct
typedef struct User {
    int id; // the same as cfd
} User;

#define MAX_USERNUM 32
User users[MAX_USERNUM] = {};
int user_num = 0;

// Message Queue 
#define MAX_MSGQUE_LEN 100000
typedef struct Message {
    char message[1024];
    int length;
} Message;
typedef struct MsgQueue {
    Message *msg_queue;
    int msg_num;
    int head;
    int tail;

    int id;
} MsgQueue;

MsgQueue msgque[MAX_USERNUM] = {};
int msgque_num = 0;

int msgQue_init(MsgQueue *msgqueue, int id) {
    msgqueue->msg_queue = (Message *)malloc(MAX_MSGQUE_LEN * sizeof(Message));
    if (!msgqueue->msg_queue) {
        printf("ERROR: Init error.\n");
        return -1;
    }
    msgqueue->head = 0;
    msgqueue->tail = 0;
    msgqueue->msg_num = 0;
    msgqueue->id = id;
    return 0;
}

void msgQue_delete(MsgQueue *msgqueue) {
    free(msgqueue->msg_queue);
}

int msgQue_addmsg(MsgQueue *msgqueue, Message *message) {
    if (msgqueue->msg_num == MAX_MSGQUE_LEN) {
        printf("ERROR: This queue is full.\n");
        return -1;
    }
    msgqueue->msg_queue[msgqueue->head] = *message;
    msgqueue->head = (msgqueue->head + 1) % MAX_MSGQUE_LEN;
    msgqueue->msg_num += 1;
    return 0;
}

int msgQue_getmsg(MsgQueue *msgqueue, Message *message) {
    if (msgqueue->msg_num == 0) {
        printf("ERROR: This queue is empty.\n");
        return -1;
    }
    *message = msgqueue->msg_queue[msgqueue->tail];
    msgqueue->tail = (msgqueue->tail + 1) % MAX_MSGQUE_LEN;
    msgqueue->msg_num -= 1;
    return 0;
}

int msgQue_isempty(MsgQueue *msgqueue) {
    return (msgqueue->msg_num == 0);
}



// The lock
pthread_mutex_t mutex = PTHREAD_MUTEX_INITIALIZER;

void send_to_all(User user, char* message, long length) {
    if (length <= 0)
        length = strlen(message);
    Message msg;
    msg.length = length;
    strcpy(msg.message, message);


    pthread_mutex_lock(&mutex);
    for (int i = 0; i < user_num; ++i) {
        if (users[i].id == user.id)   // Not self
            continue;
        // add the message to mesage queue
        msgQue_addmsg(&msgque[i], &msg);
    }
    pthread_mutex_unlock(&mutex);
}

#define MAX_RECV_SIZE 1000

void *handle_chat(void *args) {
    User user = *(User*)args;

    while (1) {
        char buffer[1024] = {}, buffer1[1024] = {};

        long len = recv(user.id, buffer + strlen(buffer), MAX_RECV_SIZE, 0);
        long len1 = 0;

        Recv_start:
        if (len <= 0) {
            for (int i = 0; i < user_num; ++i) {
                // find which one left the room
                if (users[i].id == user.id) {
                    users[i] = users[--user_num];
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
            return NULL;
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

    return NULL;
}

void *handle_queue(void *args) {
    User user = *(User *)args;

    int t = -1;
    for (int i = 0; i < user_num; i++) {
        if (msgque[i].id == user.id) {
            t = i;
            break;
        }
    }
    if (t == -1) {
        return NULL;
    }
    while (1) {
        if (!msgQue_isempty(&msgque[t])) {

            
            Message *msg = (Message *)malloc(sizeof(Message)); 

            pthread_mutex_lock(&mutex);        
            int i = 0;
               
            msgQue_getmsg(&msgque[t], msg);       
            pthread_mutex_unlock(&mutex);

            char *buffer = msg->message;
            long length = msg->length;
            long ret = 0;

            sendstart:
            ret = send(users[t].id, buffer, length, 0);
            if (ret < length) {
                buffer = buffer + ret;
                length = length - ret;
                goto sendstart;
            }
        }
    }
    return NULL;
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
    if (bind(fd, (struct sockaddr *)&addr, (socklen_t)sizeof(addr)) == -1) {
        perror("bind");
        return 1;
    }
    if (listen(fd, 32) == -1) {
        perror("listen");
        return 1;
    }

    while (1) {
        struct sockaddr_in user_addr;
        socklen_t addr_len = sizeof(user_addr);

        int user_id = accept(fd, (struct sockaddr *)&user_addr, &addr_len);
        // user id is the cfd
        if (user_id == -1) {
            perror("accept");
            return 1;
        }

        char buffer[200] = {};
        users[user_num].id = user_id;

        pthread_t thread1, thread2;

        strcpy(buffer, "User[");
        char id[10] = {};
        sprintf(id, "%d", user_id);
        strcat(buffer, id); 
        strcat(buffer, "] has joined the room.\n");
        send_to_all(users[user_num], buffer, -1);

        msgQue_init(&msgque[user_num], user_id);

        pthread_create(&thread1, NULL, handle_chat, (void *)(&users[user_num]));
        pthread_create(&thread2, NULL, handle_queue, (void *)(&users[user_num++]));
    }
}