#include <stdio.h>
#include <string.h>
#include <stdbool.h>
#include <stdlib.h>

/*
.00001 9
9.8765 4
2.0000 2
*/

char ans[100000][70] = {0};
char output[100000][70] = {0};
int ans_num = 0, out_num = 0;

int cutdots(char input[]) {  //去除小数点，并返回小数位数
	int i, j = 0, len = strlen(input), zeros = 0;
	char *newstart;
	for (i = 0; input[i] != '.' && i < len; i++);
	if (i == len) return 0;
	input[i] = '\0';
	if (i == len - 1) return 0;
	j = i+1;
	/*while (j < len - 1) {
		if (input[j] == '0') {		
			zeros++ ;
		} else {
			zeros = 0;
		}
		j++;
	}	
	printf("%d\n", zeros);
	*/
	newstart = &input[i + 1];
	strcat(input, newstart);
	return len - i - 1- zeros;
}

int multiply(char input1[], char input2[], int length1, int length2, char output[]) {
	int n1, n2, nout = 0, k = 0, max = 0;
	for (n2 = length2 - 1; n2 >= 0; n2--) {
		for (n1 = length1 - 1; n1 >= 0; n1--) {		
			nout = length1 - n1 - 1 + k;	
			output[nout] += (input1[n1]-48) * (input2[n2]-48) % 10;
			output[nout+1] += (input1[n1]-48) * (input2[n2]-48) / 10;
			max = max > nout + 1 ? max : nout + 1;
		}		
		k++;
	}
	for (n1 = 0; n1 <= nout + 2; n1++){
		if (output[n1] >= 10) {
			output[n1+1] += output[n1] / 10;
			output[n1] = output[n1] % 10;
		}
		output[n1] += 48;
	}
	//if (length == 1) nout++;
	output[max + 1] = '\0';
	return max + 1;
}

void rerank (char input[]) {  //倒序字符串 
	int len = strlen(input);
	char temp[70];
	int i;
	for (i = 0; i < len; i++){
		temp[len - i - 1] = input[i];
	}
	strcpy(input, temp);
	return;
}

int f_pow(char input[], int n, char output[]) {
	int length1 = strlen(input), i, length2 = 0;
	char one[] = "1", temp[10][70] = {0};
	length2 = multiply(input, one, length1, 1, output);
	for (i = 1; i < n; i++) {
		//这里output是反序字符串，不能直接参与乘法 
		rerank(output);
		length2 = multiply(input, output, length1, length2, temp[i]);
		strcpy(output, temp[i]);
	}
	return length2;
}

void save(char output[], int length, int fractional_length) {
	int i,j = 0;
	bool iffirst = false;
	
	if (length <= fractional_length) {
		ans[ans_num][j++] = '.';    //putchar('.');
		for (i = length; i < fractional_length; i++) {
			ans[ans_num][j++] = '0'; 
		}
		for (i = length - 1; i >= 0; i--) {
			ans[ans_num][j++] = output[i]; //putchar(output[i]);
		}
	} else {
		for (i = length - 1; i >= 0; i--){
		if (output[i] == '0' && !iffirst && (i != fractional_length-1)) {
			continue;
		}
	//	system("pause");
		//printf("2everything is fine!\n");
		if(!iffirst) iffirst = true;
			
		if (i == fractional_length - 1) ans[ans_num][j++] = '.';   //putchar('.');
		ans[ans_num][j++] = output[i];   //putchar(output[i]);
		}
	}
	ans_num++;
	//putchar('\n');
	
	//cut the 0 back
		//printf("fpart: %d\n", fractional_length);
	//	printf("%d\n", j);
	if (fractional_length) {
	//	puts(ans[ans_num - 1]);
		//rerank(ans[ans_num - 1]);
		while (ans[ans_num - 1][--j] == '0') {
			ans[ans_num - 1][j] = '\0';
		}
		if (ans[ans_num - 1][j] == '.') {
			ans[ans_num - 1][j] = '\0';
		}
	}
	
//	rerank  
}

void print(void) {
	int i;
	
	for (i = 0; i < ans_num; i++)
	puts(ans[i]);
}

int main() {
	char input[6];
	int n, outputlength, fractional_length;
	while (1) {
		if (scanf("%s %d", input, &n) == -1) break;
		fractional_length = cutdots(input) * n;	
	
		outputlength = f_pow(input, n, output[out_num]); 
	//	puts(output[out_num]);
		save(output[out_num++], outputlength, fractional_length);
		
	}
	
	print();
	return 0;
}
