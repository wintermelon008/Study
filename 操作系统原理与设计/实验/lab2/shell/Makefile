CC = g++
SRCS = shell.cpp \
	   history.cpp

OBJS = $(SRCS:.cpp = .o)

EXEC = shell

start: $(OBJS)
		$(CC) -o $(EXEC) $(OBJS)
	
.cpp.o: 
		$(CC) -o $@

clean: 
	rm -rf shell.o history.o shell