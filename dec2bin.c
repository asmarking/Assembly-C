/**
 * Assignment-1
 * CSE30 Username: cs30wi22dm 
 * Class: UCSD CSE30-WI22
 */
#include <stdio.h>
#include <stdlib.h>


int main(int argc, char* argv[]) {


    if (argc != 2) {
        fprintf(stderr, "%s wrong number of arguments\n", argv[0]);
        return EXIT_FAILURE;
    }


    unsigned int population = (unsigned) atoi(argv[1]);
  
    // put your code here (use as many lines as you need)
	int a[32],i;
          for(i=0;population>0;i++){
                  a[i]=population%2;
                  population=population/2;
          }
          int exp,y;
          exp=0;
          for(y=0;y<i;y++){
                  printf("%d * 2^%d\n",a[y],exp);
                  exp++;
		  }

    return EXIT_SUCCESS; 
}