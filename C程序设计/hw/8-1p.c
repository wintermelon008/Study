#include <stdio.h>
int main() {
	char *insert(char *string, char c);
	char string[51];
	char c;
	
	gets(string);
//	while (c = getchar() != '\n');
	scanf("%c", &c);
	insert(string, c);
	puts(string);
	return 0;
}

char *insert(char *string, char c) {
	char *p = string;
	char midch, befmidch;	
	for (; *p < c; p++);
	midch = *p;
    *p = c;
	
	while (midch != '\0') {
		p++;
		befmidch = *p;		
		*p = midch;
		midch = befmidch;
	}
}






