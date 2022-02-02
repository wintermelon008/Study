#include <stdio.h>
#include <string.h>
#include <stdlib.h>

int score(char sign) {
    if (sign == '*' || sign == '\\') {
        return 2;
    } else if (sign == '+' || sign == '-') {
        return 1;
    }
}

void rerank (char input[]) {  //µ¹Ğò×Ö·û´® 
	int len = strlen(input);
	char temp[1000];
	int i;
	for (i = 0; i < len; i++){
		temp[len - i - 1] = input[i];
	}
	strcpy(input, temp);
	return;
}

void search(char input[], char output[]) {
    int i = 0, num_sign = 0, num_number = 0;
    if (*(input) >= '0' && *(input) <= '9') {
        *(output) = *(input);
    	//output[0] = *(input);
    	return;
	}
    while (i < strlen(input)) {
        if (*(input + i) == '+' || *(input + i) == '-' || 
            *(input + i) == '*' || *(input + i) == '\\' ) {
                num_sign++;
            } else {
                num_number++;
            }
        if (i != 0 && num_sign == num_number - 1) {
            strcpy(output, input);
            *(output + i + 1) = '\0';
            //output[i+1] = '\0';
            return;
        } else {
            i++;
        }
    }
    return;
}

/*
·Ö¸î±í´ïÊ½
µİ¹éº¯Êı
*/
void divide(char input[], char output[]) {
    char left[1000] = {'\0'}, right[1000] = {'\0'};
    char newleft[1000] = {'\0'}, newright[1000] = {'\0'};
    search(input + 1, right);  //ÕÒ·ûºÅÓÒ²àµÄ±í´ïÊ½
    //puts(right);
   
   // printf("1\n");
    search(input + 1 + strlen(right), left); //ÕÒ·ûºÅ×ó²àµÄ±í´ïÊ½
   //puts(left);
    //´¦ÀíÓÒ²àµÄ×Ö·û´®Óë·ûºÅ
    if (strlen(right) == 1) {
    	strcat(output, right);
    } else if (score(*input) >= score(right[0])){
    	output[strlen(output)] = ')';
        divide(right, newright);
        strcat(output, newright);
        output[strlen(output)] = '(';
	} else {
		divide(right, newright);
        strcat(output, newright);
	}
	
    output[strlen(output)] = *(input);
    
 //puts(output);
    //´¦Àí×ó²àµÄ×Ö·û´®
    if (strlen(left) == 1) {
    	strcat(output, left);
    } else if (score(*input) > score(left[0])){
    	output[0] = ')';
        divide(left, newleft);
        strcat(output, newleft);
        output[strlen(output)] = '(';
	} else {
		divide(left, newleft);
        strcat(output, newleft);
	}
   
}

int main() {
	//12+34+*
	char input[1000] = {'\0'}, output[1000] = {'\0'};
	gets(input);	
    if (strlen(input) == 1) {
        puts(input);
    } else {
        //printf("2\n");
        rerank(input);
        divide(input, output);
        rerank(output);
        puts(output);
    }
    system("pause");
    return 0;


}
