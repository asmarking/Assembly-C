//file header
    .arch armv6     //armv6 architecture
    .arm            //arm 32-bit IS
    .fpu vfp        //floating point co-processor
    .syntax unified //modern syntax

//function imports
    .extern printf

    .section .rodata
.Lmsg1: .string "Total size: %lu\n"
.Lmsg2: .string "Total entries: %lu\n"
.Lmsg3: .string "Longest chain: %lu\n"
.Lmsg4: .string "Shortest chain: %lu\n"
.Lmsg5: .string "Empty buckets: %lu\n"

    //.data         //uncomment if needed

    .text           //start of text segment

    .global print_info               //make print_info global for linking to
    .type   print_info, %function    //define print_info to be a function
    .equ 	FP_OFF,32 // FILL THIS 	 //fp offset distance from sp

print_info:	
// function prologue

.equ ARG5,4
push {r4-r10, fp, lr}
add fp, sp, FP_OFF

// function body
//r0 table
//r1 size
//r4 head node
//r5 counter
//r6 number of empty buckets
//r7 min
//r8 max
//r9 total entries
//r10 i


mov r6, 0
mov r7, 0
mov r8, 0
mov r10, 0

cmp r10, r1
bge .Lend_for

.Lfor:   // outer loop for buckets
ldr r4,[r0]
mov r5, 0
cmp r4, 0x0
bne .Lwhile
add r6,r6,1
b	.Lend

.Lwhile:			//loop counts the size of the given bucket

add r5, 1
ldr r4, [r4,24]	//front=front->next
cmp r4, 0x0	//if(front==null)
beq .Lend
b .Lwhile
.Lend:			//first non-empty bucket

cmp r7, 0		
bne .Lnot_zero 
mov r7, r5

.Lnot_zero:			//if(counter<min)

cmp r5, r7
bge .Lnot_min
mov r7, r5

.Lnot_min:			//if(counter>max)
cmp r5, r8
	ble .Lnot_max
	mov r8, r5
	
.Lnot_max:

	add r9, r5		//total=total+counter
add r10,1		//i++
cmp r10, r1		//if(i<size)
bge .Lend_for
add r0,4		//table=table+1
blt .Lfor
//printing part

.Lend_for:

ldr r0,=.Lmsg1
bl printf
ldr r0,=.Lmsg2
mov r1,r9
bl printf
ldr r0,=.Lmsg3
mov r1,r8
bl printf
ldr r0,=.Lmsg4
mov r1,r7
bl printf
ldr r0,=.Lmsg5
mov r1,r6
bl printf

// function epilogue
sub sp, fp, FP_OFF
pop {r4-r10,fp,lr}
bx lr


// function epilogue


// function footer - do not edit below
    .size print_info, (. - print_info) // set size for function
// ==========================================================================

//file footer
    .section .note.GNU-stack,"",%progbits // stack/data non-exec (linker)
.end
