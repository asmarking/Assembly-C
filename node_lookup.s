//file header
    .arch armv6     //armv6 architecture
    .arm            //arm 32-bit IS
    .fpu vfp        //floating point co-processor
    .syntax unified //modern syntax


    //.data         //uncomment if needed

    .text           //start of text segment

    .global node_lookup               //make node_lookup global for linking to
    .type   node_lookup, %function    //define node_lookup to be a function
    .equ 	FP_OFF,32 //FILL THIS 	  // fp offset distance from sp 
		.equ  ARG5,4
		.equ NEXT,24		

node_lookup:
//function prologue 

push {r4-r10,fp,lr}
add fp, sp, FP_OFF



//function body

ldr r5,[fp,ARG5] 
cmp r0, 0x0
beq .Lexit_while

.Lwhile:
	
	ldr r4,[r0] 		//load year
	ldr r6,[r0,4]		//load month
	ldr r7,[r0,8]		//load day
	ldr r8,[r0,12]	//load hour
	
	cmp r4, r1   	//check year
	bne .Lexit_if	
	cmp r6, r2		//check month
	bne .Lexit_if
	cmp r7, r3  		//check day
	bne .Lexit_if
	cmp r8,r5		//check hour
	bne .Lexit_if

	b .Lexit_while

.Lexit_if:

 	ldr r0, [r0,24]  //seg fault here
  cmp r0, 0x0
  bne .Lwhile
	
.Lexit_while:


// function epilogue

sub sp, fp, FP_OFF
pop {r4-r10,fp,lr}
bx lr


// function footer - do not edit below
    .size node_lookup, (. - node_lookup) // set size for function

//file footer
    .section .note.GNU-stack,"",%progbits // stack/data non-exec (linker)
.end
