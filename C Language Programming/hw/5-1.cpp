#include <stdio.h>
#include <string.h>
int main() {
	int sml = 0, mid = 0, big = 0, w = 1;
	int len, i;
	char ch[1000];
	gets(ch);
	len = strlen(ch) - 1;
	for (i = 0; i <= len; i++) {
		if (ch[i] == '(') sml++;
		if (ch[i] == ')') sml--;
		if (ch[i] == '[') mid++;
		if (ch[i] == ']') mid--;
		if (ch[i] == '{') big++;
		if (ch[i] == '}') big--;
		if (sml < 0 || mid < 0 || big < 0) w = 0;
	}
	if (sml != 0 || mid != 0 || big != 0) w = 0;
	if (w == 0) printf("no");
	else printf("yes");
	return 0;
}
