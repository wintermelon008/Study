#include <stdio.h>


void rank(int *arr, int low, int high) {  //head代表排序区域首地址，num代表排序区域长度
    int i = low, j = high;
    int base = arr[low];
    if (i >= j) return;
    while (i < j){
        while (arr[j] >= base && (i < j)) j--;
        if (i < j) {
            arr[i] = arr[j];
            i++;
        }
        while (arr[i] <= base && (i < j)) i++;
        if (i < j) {
            arr[j] = arr[i];
            j--;
        }
    }
    arr[i] = base; 
    rank(arr, low , i - 1);
    rank(arr, i + 1, high);
}

int main() {
    int array[10] = {14,7,2,6,14,14,0,3,1,8};
    int i;
	rank(array, 0, 9);
	for (i = 0; i < 10; i++) printf("%d ", array[i]);
	printf("\n");
	return 0; 

}
