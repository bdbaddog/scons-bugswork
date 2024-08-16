#start from __start,
#(0)general configure
#(1)initialize gpr
#(2)initialize ppn & stack pointer
#(3)initialize some CSRs
#(4)jump to main
#(5)exit mechanism
#(6)trap handler & exception process
 .include "core_init.h"
	.text
	.global	__start
__start:

#--------------------------PART 0: general configure-------------------------

#//enable THEADISAEE
  li   x3, 0x400000                
  csrs mxstatus,x3

## enable fpu
#  li   x3, 0x6000
#  csrs mstatus,x3

#//enable fpu
  li   x3, 0x2000
  csrs mstatus,x3   #set mstatus_FS=2'b01

#//enable vector
  li   x3, 0x200                          
  csrs mstatus,x3   #set mstatus_VS=2'b01

#//enable unalign
  li   x3, 0x8000
  csrs mxstatus,x3  #set mxstatus_MM=1

#//set MM=1, UCME=1, CLINTEE=1, THEADISAEE=1
  li   x3, 0x638000
  csrs mxstatus,x3

#//set PMP
  li   x1, 0x1f00000000000000
  csrw pmpcfg0, x1             
  li   x1, 0xffffffffff
  csrw pmpaddr7, x1        
 
#//enable snoop
  csrsi msmpr, 0x1

#----------------------PART 1: initialize gpr-------------------
  li  x1, 0
  li  x2, 0
  li  x3, 0
  li  x4, 0
  li  x5, 0
  li  x6, 0
  li  x7, 0
  li  x8, 0
  li  x9, 0
  li  x10,0
  li  x11,0
  li  x12,0
  li  x13,0
  li  x14,0
  li  x15,0
  li  x16,0
  li  x17,0
  li  x18,0
  li  x19,0
  li  x20,0
  li  x21,0
  li  x22,0
  li  x23,0
  li  x24,0
  li  x25,0
  li  x26,0
  li  x27,0
  li  x28,0
  li  x29,0
  li  x30,0
  li  x31,0


#-------------------------PART 2: initialize ppn & stack pointer---------------------
  csrr x3,mhartid
  li x4,1

  .global cpu_0_sp	
cpu_0_sp:
  la x2, __kernel_stack


#-----------------------------PART 3: initialize some CSRs-------------------------
#//initialize mtvec value  
  la    x3,__trap_handler
  csrw  mtvec,x3

#//enable MIE
  li   x3, 0x8
  csrs mstatus,x3

#//config mcor: set CACHESEL=2'b11(sel icache & dcache), INV=1, BHT_INV=1, BTB_INV=1(invalid all)
  li x3, 0x70013
  csrs 0x7c2,x3  
 
#//config mhcr: enable icache, dcache, WA, WB, RS, BPE, BTB, IBPE, WBR, LOBTB
  li x3, 0x11ff
  csrs mhcr,x3 
  
  .global after_l2en 
after_l2en:
#//config mhcr: enable icache, dcache, WA, WB, RS, BPE, BTB, IBPE, WBR, LOBTB
  li x3, 0x11ff
  csrs mhcr,x3 

#//config mhint: enable dcache_prefetch,icache_prefetch,LPE,spec_fail_pred; set AMR=1, D_DIS=3
  li x3, 0x6e30c
  csrs mhint,x3  

#//enable L2Cache, L2Cache_prefetch; set IPRF=3; Actually RFE is fixed to 1
  li x3, 0xe0000009
  csrs mccr2,x3 

#-----------------------------PART 4: jump to main-------------------------
  jal	main


#--------------------------------------PART 5: exit mechanism------------------------------
#//case success exit mechanism, load a specified imm(0x444333222) to a register
#//tb.v can scan the special operation.
  .global __exit
__exit:
  addi x10,x0,0x0
  addi x1,x0,0x5a
  addi x2,x0,0x6b
  addi x3,x0,0x7c
  sync
  li   x3, 0x444333222
  add x4,x0,x3

#//case fail exit mechanism, load a specified imm(0x2382348720) to a register
#//tb.v can scan the special operation.
  .global __fail
__fail:
  addi x10,x0,0x0
  addi x1,x0,0x2c
  addi x2,x0,0x3b
  sync
  li x3,0x2382348720


#--------------------------------------PART6: trap_handler & exception process------------------------------
.section .text
__trap_handler:
  j __synchronous_exception
  .align 2
  j __asychronous_int
  .align 2
  nop #reserved
  .align 2
  j __asychronous_int
  .align 2
  j __asychronous_int
  .align 2
  j __asychronous_int
  .align 2
  nop #reserved
  .align 2
  j __asychronous_int
  .align 2
  j __asychronous_int
  .align 2
  j __asychronous_int
  .align 2
  nop #reserved
  .align 2
  j __asychronous_int
  j __fail

__synchronous_exception:
#//push stack
  sw   x13,-4(sp)
  sw   x14,-8(sp)
  sw   x15,-12(sp)

#//extract int information
  csrr x14,mcause   
  andi x15,x14,0x7ff  #get the exception code
  srli x14,x14,0x3b   #get the interrupt bit,{interrupt bit,4'b0000}
  andi x14,x14,0x10   #mask bit, x14 is interrupt bit
  add  x14,x14,x15    #{int,cause}

#//calculate the exception entry addr
  slli x14,x14,0x3    #offset
  la   x15,vector_table
  add  x15,x14,x15    #target pc
  lw   x14, 0(x15)    #get exception entry addr

#//pop stack
  ld   x13, -8(sp)    #recover x13
  ld   x15, -24(sp)   #recover x15
  addi x14,x14,-4
  jr   x14

__asychronous_int:
#//push stack
  sd   x13,-8(sp)
  sd   x14,-16(sp)
  sd   x15,-24(sp)

#//extract int information
  csrr x14,mcause   
  andi x15,x14,0x7ff  #get the exception code
  srli x14,x14,0x3b   #get the interrupt bit,{interrupt bit,4'b0000}
  andi x14,x14,0x10   #mask bit, x14 is interrupt bit
  add  x14,x14,x15    #{int,cause}

#//calculate the exception entry addr
  slli x14,x14,0x3    #offset
  la   x15,vector_table
  add  x15,x14,x15    #target pc
  lw   x14, 0(x15)    #get exception entry addr

#//pop stack
  lw   x13, -4(sp)    #recover x13
  lw   x15, -12(sp)   #recover x15
  addi x14,x14,-4
  jr   x14

.global mvector_table
.global vector_table
 .align  10
  mvector_table:
  vector_table:   #totally 256 entries
  .rept   128
  .long   __fail
  .endr

  .global __dummy
__dummy:  
  
  .data
  nop
  nop
  nop


