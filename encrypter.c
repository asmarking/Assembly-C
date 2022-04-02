#include <stdio.h>
#include <stdlib.h>
#include <string.h>
	
#define MAX_LEN 256 // maximum length of a single word
char rotate(char,int);
int main(int argc, char* argv[]) {
  char word[MAX_LEN];
	int shift = atoi(argv[2]);
  FILE* fin = NULL;
	fin = fopen(argv[1],"r"); 
	if(argc!=3){
		printf("expecting three arguments");
	}
  if(fin == NULL) {
    perror("Could not open input file.");
    return 1;
  }

  // TODO: Write your code here
 /*
	* need to first read in each charachter and store it in an array
	* then call the rotate function on a single char  
	*/
	
	//rotate method

	char rotate(char c,int n) {
		int index;
		char ch;
		if('A' <= c && c <= 'Z' ){
			index = ((( c - 65)+n) % 26) + 65 ;
			ch = index;
			return ch;
		}
		else if('a' <= c && c <= 'z') {
			index = (((c-97)+n) % 26) + 97;
			ch = index;
			return ch;
		}
		else{
			return c ;
		}	
	}	  
		
	int cin;
	int count=0;
	int i = 0;
	while((cin = fgetc(fin)) != EOF){
	// add each char into array and print it out when cin==' ' or cin==/n
		if(cin==' ' || cin=='\n') {
			for(int j=count-1;j>=0;j--){
				printf("%c",rotate(word[j],shift));	// call rotate on word[j];
			}
			if(cin=='\n') {
				printf("\n");
				count=0;
				i=0;
				continue;
			}
		printf(" ");
		count=0;
		i=0;
		continue;
	}
//printf("%d",i);
	word[i] = cin;
	i++ ;
	count++;
	}
 // clean up gracefully
  fclose(fin);

  return 0;
   }
