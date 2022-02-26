#include <stdio.h>
int main() {
	char *insert(char *string, char c);
	char string[51] = {'0'};
	char c;
	int i = 0;
	
	gets(string);
	scanf("%c", &c);
	insert(string, c);
	printf("%s", string);
	return 0;
}

char *insert(char *string, char c) {
	char *p = string;
	char midch, befmidch;
	while (*(p++) < c);
	*(p-1) = c;
	while (midch != '\0') {
		p++;
		befmidch = *p;
		*p = midch;
		midch = befmidch;
	}
	//printf("%c\n", *p);
}
