#include <stdio.h>

int fib_seq(int n){
    if(n==0){
        return 0;
    }
    else if(n==1){
        return 1;
    }
    else{
        return fib_seq(n-1)+fib_seq(n-2);
    }
}

int main(){
    unsigned int idx;
    printf("Please input a number: ");
    scanf("%d",&idx);
    printf("%d\n",fib_seq(idx));
    return 0;
}