//file header
    .arch armv6     //armv6 architecture
    .arm            //arm 32-bit IS
    .fpu vfp        //floating point co-processor
    .syntax unified //modern syntax


    //.data         //uncomment if needed

    .text           //start of text segment

    .global node_lookup               //make node_lookup global for linking to
    .type   node_lookup, %function    //define node_lookup to be a function
    .equ 	FP_OFF,0x8 //FILL THIS 	  // fp offset distance from sp 
node_lookup:	
// function prologue
.equ FP_OFFSET, 12
.equ ARG5,4
push {r4,r5,fp,lr}
add fp, sp, FP_OFFSET

//function body 

cmp r0, 0x0
beq .Lexit_while

.Lwhile:

    ldr r4, [r0]		//Check year
    cmp r4, r1
    bne .Lexit_if

    ldr r4, [r0,4]		//Check month
    cmp r4, r2
    bne .Lexit_if

    ldr r4, [r0,8]		//Check day
    cmp r4, r3
    bne .Lexit_if

    ldr r4, [r0,12]		//Check hour
    ldr r5,[fp,ARG5] 
		cmp r4,r5
    bne .Lexit_if

    b .Lexit_while

.Lexit_if:

 ldr r0, [r0, 24] 
    cmp r0, 0x0
    bne .Lwhile

.Lexit_while:

//function epilogue
 
    sub sp, fp, FP_OFFSET
    pop {r4,r5,fp,lr}
    bx lr



// function footer - do not edit below
    .size node_lookup, (. - node_lookup) // set size for function

//file footer
    .section .note.GNU-stack,"",%progbits // stack/data non-exec (linker)
.end
