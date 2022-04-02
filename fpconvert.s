//file header
    .arch armv6     //armv6 architecture
    .arm            //arm 32-bit IS
    .fpu vfp        //floating point co-processor
    .syntax unified //modern syntax

//definitions applying to the entire source file
    //.equ EXAMPLE_DEF, 0xff

    //.data         //uncomment if needed

    .text           //start of text segment

    .global fpconvert               //make fpconvert global for linking to
    .type   fpconvert, %function    //define fpconvert to be a function
    .equ 	FP_OFF, 32 	            //fp offset distance from sp (# of saved regs - 1) * 4

fpconvert:	
// function prologue - do not edit this part
    push    {r4-r10, fp, lr}    // save registers to stack
    add     fp, sp, FP_OFF      // set frame pointer to frame base

// you can use any of r0-r10 inclusive
// R0 is the parameter to the function
// the last value of R0 is the value
// returned from the function
// ==========================================================================
// YOUR CODE GOES IN THE SECTION BELOW
// ==========================================================================
	
	lsr r1,r0,13       	  // r1 = r0 >> 13
	lsl r1,r1,31       	  // r1 = r1 >> 31
	lsr r2,r0,7        	  // r2 = r0 >> 7
	lsl r2,r2,26       	  // r2 = r2 >> 26
	lsr r2,r2,26  	      // r2 = r2 >> 26
	mov r8,r2          	  // r8 = r2
	cmp r2,0x3f 	      // if(r2 == 63) {  
	beq .Lconvert_inf     //		convert_infinity
	cmp r2,0x0 			  // }
	bne .L_exp_not_zero   // if(r2==0){		 				
.L_exp_zero:			  //
	lsl r3,r0,25		  // 	r3 << 25
	lsr r3,r3,25		  // 	r3 >> 25}
	cmp r3,0x0  		  //	}
	beq .Lmantissa_zero	  // 
	cmp r3,0x1			  //
	beq .Lmantissa_one    //
	b .Lmantissa_denormal //   
						  // if(r3 == 0){
.Lmantissa_zero:		  // 	if(r1 == 0){ 
	cmp r1,0x0			  //			r7 = 0 
	bne .Lnegative_zero	  //			r0 = r7 
	mov r7,0x0			  //			return r0 
	mov r0,r7			  //		}
	b .Lskip_to_end		  // 
                          //
.Lnegative_zero:		  //		if(r1==1){
	mov r7,0x8			  //			r7 = 8
	lsl r7,r7,28		  //			r7 << 28
	mov r0,r7			  //			r0 = r7
	b .Lskip_to_end		  //			return r0
						  // 	}
						  // }
.Lmantissa_one:			  //	if(r3==1){
	cmp r1,0x0			  //		if(r1==0){
	bne .Lnegative_small  //			r7 = 45
	mov r7,0x2d			  //			r7 << 24
	lsl r7,r7,24		  //      
	mov r0,r7             //			r0 = r7
	b .Lskip_to_end		  //			return r0
				   		  //		}
.Lnegative_small:		  //		else{
	mov r7,0xad			  //			r7 = 173
	lsl r7,r7,24		  //			r7 << 24
	mov r0,r7			  //  	r0 = r7
	b .Lskip_to_end       //		}  
						  // }
                          //
	                      //	if(r3==0 && r1!=0 
.Lmantissa_denormal:      //	&& r1!=1){ 
	add r2,0x1			  // 
	mov r9,0x0			  //		r9 = 0
.Lnormalizing:			  //		r5 = r3 && 64
	and r5,r3,0x40		  //		while(r5!=64){
	cmp r5,0x40			  //			r3 << 1
	beq .Lnormalized_now  //			r9 +=1
	lsl r3,r3,1			  //			r5 = r3 && 64
	add r9,r9,0x1		  //		}
	b .Lnormalizing       // 
.Lnormalized_now:         // 
	add r9,r9,0x1         //		r9 +=1
	sub r2,r2,r9          //		r2 = r2 - r9   
	lsl r3,r3,1           //		r3 << 26
	lsl r3,r3,25          //		r3 >> 9 
	lsr r3,r3,9           // }
.L_exp_not_zero:          //      
	sub r6,r2,31          // r6 = r2 - 31
	add r6,r6,127         // r6 = r6 + 127
	lsl r6,r6,23          // r6 << 23
	cmp r9,0x0            // if(r9 == 0){
	bne .Ldenormal_hand   //
	lsl r3,r0,25          //		r3 = r0 << 25
	lsr r3,r3,9           //		r3 = r3 >> 9
                          // }
.Ldenormal_hand:          //
                          //	else{
	orr r4,r1,r6          //		r4 == r1 || r6
	orr r5,r4,r3          //		r5 == r4 || r3
	mov r0,r5             //		r0 = r5
                          // }     
.Lskip_exp_not_zero:      //
                          //
                          //  
                          //
b .Lskip_convert_inf      //this is for when number is not infinite make sure u dont do this
                          //
.Lconvert_inf:            //
	bl convert_infinity   //call convert infinity
                          //
.Lskip_convert_inf:       //no purpose except to avoid convert in 
.Lskip_to_end:            //sole purpose to skip to the end when needed

// ==========================================================================
// function epilogue - do not edit
    sub	sp, fp, FP_OFF
    pop     {r4-r10, fp, lr}     // MUST MATCH LIST IN PROLOG'S PUSH
    bx      lr                   // return

// function footer
    .size fpconvert, (. - fpconvert) // set size for function

// ==========================================================================

    .global convert_infinity
    .type   convert_infinity, %function
    .equ    FP_OFF, 32
// make a 32-bit IEEE +Inf or -Inf
convert_infinity:	
// function prologue (do not edit)
    push    {r4-r10, fp, lr}    // save regs
    add     fp, sp, FP_OFF
// you can use any of r0-r10 inclusive
// R0 is the parameter to the function
// the last value of R0 is the value
// returned from the function
// r4-r10 are local to this function
// changes to these values will not be reflected
// in the main function.

// ==========================================================================
// YOUR CODE GOES IN THE SECTION BELOW
// ==========================================================================
lsr r1,r0,13             // r1 = r0 >> 13
cmp r1,0x0               // if(r1 == 0){
bne .Lnegative_infinity  // 
mov r7,0x7f              //   r7 = 127
lsl r7,r7,4              //   r7 += 4
orr r7,r7,0x8            //   r7 = r7 || 8
lsl r7,r7,20             //   r7 << 20
mov r0,r7                //   r0 = r7
bl .Lelse                //  }    
.Lnegative_infinity:     // else{
mov r7,0xff              //   r7 = 255
lsl r7,1                 //   r7 << 1
orr r7,r7,0x1            //   r7 = r7 || 1
lsl r7,r7,23             //   r7 << 23
mov r0,r7                //   r0 = r7
.Lelse:                  // }

// ==========================================================================
// function epilogue (do not edit)
    sub	sp, fp, FP_OFF
    pop     {r4-r10, fp, lr}    // restore regs
    bx      lr                  // return
// function footer
    .size convert_infinity, (. - convert_infinity)

//file footer
    .section .note.GNU-stack,"",%progbits // stack/data non-exec (linker)
.end
