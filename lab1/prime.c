#include<stdio.h>

int prime();

int main(){
	int n=0, flag=0;
	printf("Please input a number: ");
	scanf("%d", &n);

	if(prime(n)){
		printf("It's a prime\n");
	}
	else{
		printf("It's not a prime\n");
	}
	return 0;
}

int prime(int n){
	if (n==1){
		return 0;
	}
	for (int i=2;i*i<=n;i++){
		if (n%i == 0){
			return 0;
		}
	}
	return 1;
}
