#include <stdio.h>
#include <string.h>
int main() {
	char *insert(char *string, char c);
	char string[51] = {'0'};
	char c;
	
	gets(string);
	scanf("%c", &c);
	insert(string, c);
	puts(string);
	return 0;
}

char insert(char *string, char c) {
	int i = 0, len = strlen(string);
	char midch, befmidch;
	while (*(string + i) < c) {
		i++;
		if (i >= len) break;
	}
	midch = *(string + i);
	*(string + i) = c;	
    
	while (midch != '\0') {
		i++;
		befmidch = *(string + i);		
		*(string + i) = midch;
		midch = befmidch;
	}
}
