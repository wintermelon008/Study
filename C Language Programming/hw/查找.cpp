//http://www.bailian.openjudge.cn/practice/2804 
#include <stdio.h>
#include <string.h>

struct DICTIONARY {
    char Ewords[21];   //英语单词
    char Fwords[21];   //外语单词
} dictionary[100000];
char lines[100000][21];
typedef struct DICTIONARY dict;

void rank(dict *head, int length) {  //length为 字典元素个数
    dict *p = head;
    char temp[21];
    int i, j, w;
    for (i = 0; i < length; i++) {
        w = 0;      
        for (j = i; j < length; j++) {
            if (strcmp((p + i)->Fwords, (p + j)->Fwords) >= 0) {
                //交换对应字典顺序
                strcpy (temp, (p + i)->Fwords); strcpy ((p + i)->Fwords, (p + j)->Fwords); strcpy ((p + j)->Fwords, temp);
                strcpy (temp, (p + i)->Ewords); strcpy ((p + i)->Ewords, (p + j)->Ewords); strcpy ((p + j)->Ewords, temp);
                w = 1;
            } 
        }
        if (w == 0) return;  //检测：如果没有交换则代表排序完成
    }
    return;
}

int search(dict *head, int length, char aim[]) {
    dict *p = head;
    int min = 0, max = length - 1, mid = (min + max) / 2;
    while ((max - min) != 1 ) {
        if (strcmp((p + mid)->Fwords, aim) < 0) {
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
	char str[50];
    const char *delim = " ";
    int words = 0, aimwords = 0, i, ans;
    while (1) {
    	gets(str);
    	if (str[0] == '\0') break;
    	strcpy(dictionary[words].Ewords, strtok(str, delim));
    	strcpy(dictionary[words].Fwords, strtok(NULL, delim));
        //scanf("%s %s", dictionary[words].Ewords, dictionary[words].Fwords);
        //if (strcmp(dictionary[words].Ewords, "0") == 0) break;
        words++;
    }
    rank(dictionary, words);
   
    while (1) {
        if (scanf("%s", lines[aimwords]) == EOF) break;
       // if (strcmp(lines[aimwords], "0") == 0) break;
        aimwords++;
    }
    
     /*
    for (i = 0; i < words; i++) {
        printf("%s %s\n", dictionary[i].Ewords, dictionary[i].Fwords);
    }
   //*/
    //printf("%d\ncheck\n", aimwords);
    
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
    //system("pause");
    return 0;
}
