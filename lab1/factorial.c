#include <stdio.h>
int fact();
int main (){
	int n, result;
	printf("Please input a number: ");
	scanf("%d",&n);
	result=fact(n);
	printf("The result of factorial(n) is %d \n ",result);
	
	return 0;
}

int fact(int a){
	if (a==1||a==0){
		return 1;
	}
	else{
		return fact(a-1)*a;
	}
}
