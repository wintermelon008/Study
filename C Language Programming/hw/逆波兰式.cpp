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

void rerank (char input[]) {  //倒序字符串 
	int len = strlen(input);
	char temp[1000];
	int i;
	for (i = 0; i < len; i++){
		temp[len - i - 1] = input[i];
	}
	strcpy(input, temp);
	return;
}
/*
 *寻找函数
 *用于在input字符串中找到一个完整的表达式并返回
 */
char *search(char *input) {
    char output[1000] = {'\0'};
    int i = 0, num_sign = 0, num_number = 0;
    if (*(input) >= '0' && *(input) <= '9') {
    	output[0] = *(input);
    	return output;
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
            output[i+1] = '\0';
            return output;
        } else {
            i++;
        }
    }
    return input;
}

/*
分割表达式，成为一左一右两个式子
*/
char *divide (char *input) {
    char left[1000] = {'\0'},  right[1000] = {'\0'}, output[1000] = {'\0'};
    left[0] = '0',  right[0] = '0'; 
    int llen = 0, rlen = 0;
    int wl = 0, wr = 0;
    strcpy(right, search(input + 1));
   // puts(right);
    rlen = strlen(right);
    if (strlen(right) != 1 && score(*(input)) >= score(*(right))) {
    	wr = 1;
	}
    if (strlen(right) != 1) {
    	strcpy(right, divide(right));
	}
//puts(input);
//puts(right);
///system("pause");
    if (wr) {
        output[0] = ')';
        strcat(output, right);
        output[strlen(output)] = '(';
        output[strlen(output)] = *input;
    } else {
        strcpy(output, right);
        //puts(output);
        output[strlen(output)] = *input;
    }
//puts(output);
//system("pause");
    strcpy(left, search(input + 1 + rlen));
    //puts(left);
    llen = strlen(left);
    if (strlen(left) != 1 && score(*(input)) > score(*(left))) {
    	wl = 1;
	}
    if (strlen(left) != 1) {
    	strcpy(left, divide(left));
	}

    if (wl) {
        output[strlen(output)] = ')';
        strcat(output, left);
        output[strlen(output)] = '(';
    } else {
        strcat(output, left);
    }
//puts(output);
//system("pause");
    return output;
}
int main() {
	//12+34+*
	char input[1000], output[1000];
	gets(input);	
	//puts(input + 1);
	int len = strlen(input);
	if (len == 1) {
		puts(input);
	}
	else {
		rerank(input);
		strcpy(output, divide(input));
		rerank(output);
		puts(output);
	}
	
	return 0;
}
