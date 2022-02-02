//http://www.bailian.openjudge.cn/practice/2804 
#include <stdio.h>
#include <string.h>

struct DICTIONARY {
    char Ewords[21];   //Ó¢Óïµ¥´Ê
    char Fwords[21];   //ÍâÓïµ¥´Ê
} dictionary[100000];
char lines[100000][21];
typedef struct DICTIONARY dict;

void rank(dict *arr, int start, int end) {
	int i = start, j = end;
	dict base = arr[start];
	if (i >= j) return;
	while (i < j) {
		while (strcmp(arr[j].Fwords, base.Fwords) < 0 && i < j) j--;
		if (i < j) {
			arr[i] = arr[j];
			i++;
		}
		while (strcmp(arr[i].Fwords, base.Fwords) > 0 && i < j) i++;
		if (i < j) {
			arr[j] = arr[i];
			j--;
		}
	}
	arr[i] = base;
	rank(arr, start , i - 1);
    rank(arr, i + 1, end);
}

int search(dict *head, int length, char aim[]) {
    dict *p = head;
    int min = 0, max = length - 1, mid = (min + max) / 2;
    while ((max - min) != 1 ) {
        if (strcmp((p + mid)->Fwords, aim) > 0) {
            min = mid;
        } else {
            max = mid;
        } 
        mid = (min + max) / 2;
	}
	if (strcmp((p + min)->Fwords, aim) == 0) return min;
	if (strcmp((p + max)->Fwords, aim) == 0) return max;
	return -1;
		
    
}

int main(void) {
	char str[30];
    const char *delim = " ";
    int words = 0, aimwords = 0, i, ans;
    while (1) {
    	gets(str);
    	if (str[0] == '\0') break;
    	strcpy(dictionary[words].Ewords, strtok(str, delim));
    	strcpy(dictionary[words].Fwords, strtok(NULL, delim));
        words++;
    }
    rank(dictionary, 0, words);
    /*
    for (i = 0; i < words; i++) {
        printf("%s %s\n", dictionary[i].Ewords, dictionary[i].Fwords);
    }
    */
	///*
   
    while (1) {
        if (scanf("%s", lines[aimwords]) == EOF) break;
        aimwords++;
    }

    for (i = 0; i < aimwords; i++) {
        ans = search(dictionary, words, lines[i]);
        if (ans == -1) {
            strcpy(lines[i], "eh");
        } else {
            strcpy(lines[i], dictionary[ans].Ewords);
        }
    }

    for (i = 0; i < aimwords; i++) {
        printf("%s", lines[i]);
        if (i != aimwords - 1) printf("\n");
    }
    //*/
    return 0;
}
