#include <stdio.h>
#include <string.h>
#include <stdbool.h>

char ans[10000][70] = {0};
int numberofans = 0;

int cutdots(char input[]) {  //去除小数点，并返回小数位数
	int i, len = strlen(input);
	char *newstart;
	for (i = 0; input[i] != '.' && i < len; i++);
	if (i == len)return 0;
	
	input[i] = '\0';
	if (i == len - 1) return 0;
	
	newstart = &input[i + 1];
	strcat(input, newstart);
	return len - i - 1;
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
///*

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
	//puts(output);
//	rerank(output);
//	puts(output);
//	puts(input);
	for (i = 1; i < n; i++) {
		//这里output是反序字符串，不能直接参与乘法 
		rerank(output);
			//puts(output);
			//puts(input);
		length2 = multiply(input, output, length1, length2, temp[i]);
	//	puts(temp);
		strcpy(output, temp[i]);
		//strcpy(temp, "0");
	//	
		//puts(output);
	}
	return length2;
}
////*/

void print(char output[], int length, int fractional_length) {
	int i;
	bool iffirst = false;
	
	if (length <= fractional_length) {
		putchar('.');
		for (i = length; i < fractional_length; i++) {
			putchar('0');
		}
		for (i = length - 1; i >= 0; i--) {
			putchar(output[i]);
		}
	} else {
		for (i = length - 1; i >= 0; i--){
		if (output[i] == '0' && !iffirst && (i != fractional_length)) {
			continue;
		}
		if(!iffirst) iffirst = true;
			
		if (i == fractional_length - 1) putchar('.');
		putchar(output[i]);
		}
	}
	
	//putchar('\n');
}

int main() {
	char input1[70] = {"8"}, input2[70] = {"0002"}, output[70] = {0};
	int inputlength1, inputlength2, outputlength, n = 10;
	int fractional_length1, fractional_length2, fractional_length;
	//puts(input);	
	fractional_length1 = cutdots(input1);
	fractional_length2 = cutdots(input2);
	inputlength1 = strlen(input1);
	inputlength2 = strlen(input2);
//	printf("inputlength: %d\n", inputlength);
	//puts(input);
	
	outputlength = f_pow(input1, n ,output);
	//outputlength = multiply(input1, input2, inputlength1, inputlength2, output);
//	puts(output);
	fractional_length = n * fractional_length1;
	//printf("fractional_part: %d\n", fractional_length);
	

	
//	printf("inputlength: %d\n", inputlength);
//	printf("outputlength: %d\n", outputlength);
	print(output, outputlength, fractional_length);
	return 0;
}

