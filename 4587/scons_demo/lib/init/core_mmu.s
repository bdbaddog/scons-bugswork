#############################################################################################################################
# This file includes some macros which will be used to set mmu related setting.                
#                                 Included Macro                                               
#  1.  MMU_EN                     SET SATP.MODE = 8, Sv39                                            
#  2.  MMU_EN_SV_39               SET SATP.MODE = 8, Sv39                                            
#  3.  MMU_EN_SV_48               SET SATP.MODE = 9, Sv48                                            
#  4.  MMU_DIS                    SET SATP.MODE = 0, Bare                                            
#  5.  MMU_MODE_SWITCH            SWITCH MMU_MODE                                                     
#  6.  SWITCH_TO_SV48             SWITCH MMU_MODE to Sv48                                            
#  7.  SWITCH_TO_SV39             SWITCH MMU_MODE to Sv39                                            
#  8.  MMU_PTW_4K                 Prcocess PTW_4K: set {SVPBMT,PPN,FLAG} to level3-page PTE in SV39/level4-page PTE in SV39 
#  9.  MMU_PTW_2M                 Prcocess PTW_2M: set {SVPBMT,PPN,FLAG} to level2-page PTE in SV39/level3-page PTE in SV39           
#  10. MMU_PTW_1G                 Prcocess PTW_1G: set {SVPBMT,PPN,FLAG} to level1-page PTE in SV39/level2-page PTE in SV39
#  11. MMU_PTW_512G               Prcocess PTW_512G: set {SVPBMT,PPN,FLAG} to level1-page PTE in SV48
#  12. MMU_W_MIR                  SET SMIR = {48'b0, INDEX}, INDEX = {iutlb,dutlb,4'b0,index}               
#  13. MMU_W_MEL                  SET SMEL = {CSKYFLAG, PMPFLAG, PFN, FLAG}        
#  14. MMU_W_MEL_REG              SET SMEL = {CSKYFLAG, PMPFLAG, PFN, FLAG} using reg
#  15. MMU_W_MEH                  SET SMEH = {PAGESIZE[3],VPN,PAGESIZE[2:0],ASID}
#  16. MMU_W_MEH_REG              SET SMEH = {PAGESIZE[3],VPN,PAGESIZE[2:0],ASID} using reg
#  17. MMU_W_MEH_REG_TEE          SET SMEH = {PAGESIZE[3], ZONEID, VPN,PAGESIZE[2:0],ASID} using reg
#  18. MMU_E_P                    SET SMCIR.TLBP = 1'b1  
#  19. MMU_E_R                    SET SMCIR.TLBR = 1'b1    
#  20. MMU_E_WI                   SET SMCIR.TLBWI = 1'b1                                             
#  21. MMU_E_WR                   SET SMCIR.TLBWR = 1'b1    
#  22. MMU_E_INV                  SET SMCIR.IASID = 1'b1 & SMCIR.ASID = ASID
#  23. MMU_E_INV_ALL              SET SMCIR.IALL = 1'b1
#  24. MMU_E_INVI                 INVALID the TLB with TLBINDEX
#  25. MMU_E_TINV_ALL             SET SMCIR.??
#  26. MMU_SATP_PPN               SET SATP.PPN = PPN
#  27. MMU_SATP_ASID              SET SATP.ASID = ASID
#  28. MMU_SATP_ASID_REG          SET SATP.ASID = ASID_REG using reg
#  29. RECOVER_MMU                FLUSH TLB & SET level-1 page PTE = {0xf, 49'b0, 2'b0,0xff} & set mstatus.sum = 1'b1
#  30. MSTATUS_MPRV               SET MSTATUS.MPRV = IMM                                              
#  31. MSTATUS_SUM                SET MSTATUS.SUM = IMM                                          
#  32. MSTATUS_MXR                SET MSTATUS.MXR = IMM                                              
#  33. MSTATUS_TVM                SET MSTATUS.TVM = IMM                                              
#  34. MSTATUS_MPP                SET MSTATUS.MPP = IMM                                              
#  35. MXSTATUS_MAEE              SET MXSTATUS.MAEE = IMM                                            
#  36. MXSTATUS_MHRD              SET MXSTATUS.MHRD = IMM                                            
#  37. MXSTATUS_CSKYISAEE         SET MXSTATUS_THEADISAEE = IMM                                      
#  38. MXSTATUS_MM                SET MXSTATUS.MM = IMM                                              
#  39. MXSTATUS_UCME              SET MXSTATUS.UCME = IMM                                            
#  40. MXSTATUS_INSDE             SET MXSTATUS.INSDE = IMM                                           
#  41. MXSTATUS_CLINTEE           SET MXSTATUS.CLINTEE = IMM                                         
#  42. MXSTATUS_FCCEE             SET MXSTATUS.FCCEE = IMM ??  
#  43. MENVCFG_PBMTE              SET MENVCFG_PBMTE = IMM                                      
#  44. FXCR_DQNaN                 SET FXCR.DQNaN = IMM                                               
#  45. PMPCFG0_0                  SET PMPCFG.entry0_cfg = IMM                                        
#  46. PMPCFG0_1                  SET PMPCFG.entry1_cfg = IMM                                        
#  47. PMPCFG0_2                  SET PMPCFG.entry2_cfg = IMM                                        
#  48. PMPCFG0_3                  SET PMPCFG.entry3_cfg = IMM                                        
#  49. PMPCFG0_4                  SET PMPCFG.entry4_cfg = IMM                                        
#  50. PMPCFG0_5                  SET PMPCFG.entry5_cfg = IMM                                        
#  51. PMPCFG0_6                  SET PMPCFG.entry6_cfg = IMM                                        
#  52. PMPCFG0_7                  SET PMPCFG.entry7_cfg = IMM                                        
#  53. MMU_MMODE_SMODE            SET MSTATUS.MPP = 2'b01 MEPC = SROUTINE                            
#  54. MMU_MMODE_SMODE_S          SET MSTATUS.SPP = 1'b1 SPEC = SROUTINE                             
#  55. MMU_SMODE_UMODE            SET STATUS.SPP = 1'b0 SEPC = UROUTINE                              
#  56. MMU_MMODE_UMODE            SET MSTATUS.MPP = 2'b0 MEPC = UROUTINE                             
#  57. MMU_MMODE_UMODE_S          SET MSTATUS.SPP = 0 SEPC = UROUTINE                                
#  58. MMU_RV32_DEFAULT_INIT      Initialize MMU                                        
#  59. MMU_PTW_ADDR_4K            Get 4K page(napot or not) addr
#  60. MMU_PTW_ADDR_2M            Get 2M page(leaf/non-leaf) addr        
#  61. MMU_PTW_ADDR_1G            Get 1G page(leaf/non-leaf) addr
#  62. MMU_PTW_ADDR_512G          Get 512G page(leaf/non-leaf) addr   
#  63. MMU_PTW_4K_NAPOT           Make 4K NAPOT single pte    
#  64. MMU_PTW_4K_NAPOT_REG       Make 4K NAPOT single pte using reg
#  65. MMU_PTW_4K_NAPOT_ALL       Make 4K NAPOT all 16 ptes                   
#############################################################################################################################


#//---------------1. SET SATP.MODE = 8, Sv39---------------//
.macro MMU_EN
  #//backup regs
  addi	x2, x2, -16
  sd	x9, 0(x2)
  sd	x10, 8(x2)

  #//write MODE=8 to SATP
  csrr  x9,satp
  li    x10,0xfffffffffffffff
  and   x9,x9,x10  #set SATP.MODE = 4'b0
  li    x10,8
  slli  x10,x10,60 
  or    x9,x9,x10  #set SATP.MODE = 4'b1000
  csrw	satp, x9

  #//restore regs
  ld	x10, 8(x2)
  ld	x9, 0(x2)
  addi	x2, x2, 16
.endm


#//---------------2. SET SATP.MODE = 8, Sv39---------------//
.macro MMU_EN_SV_39
  li    x10,0xf000000000000000
  csrc	satp, x10  #clr SATP.MODE
  li    x10,0x8000000000000000
  csrs	satp, x10  #set SATP.MODE = 4'b1000
.endm


#//---------------3. SET SATP.MODE = 9, Sv48---------------//
.macro MMU_EN_SV_48
  li    x10,0xf000000000000000
  csrc	satp, x10  #clr SATP.MODE
  li    x10,0x9000000000000000
  csrs	satp, x10  #set SATP.MODE = 4'b1001
.endm


#//---------------4. SET SATP.MODE = 0, Bare---------------//
.macro MMU_DIS
  #//backup regs
  addi	x2, x2, -16
  sd	x9, 0(x2)
  sd	x10, 8(x2)

  #//write MODE=0 to SATP
  csrr  x9,satp
  li    x10,0xfffffffffffffff
  and   x9,x9,x10
  csrw	satp, x9

  #//restore regs
  ld	x10, 8(x2)
  ld	x9, 0(x2)
  addi	x2, x2, 16
.endm


#//---------------5. SWITCH MMU_MODE---------------//
.macro MMU_MODE_SWITCH MMU_MODE 
  #//backup regs
   addi	x2, x2, -24
   sd	x9, 0(x2)
   sd	x10, 8(x2)
   sd	x11, 16(x2)
 
  #//if \MMU_MODE is Sv39, then jump to switch to Sv39
  li x9, \MMU_MODE
  li x10,0x8
  beq x9, x10, 1f
 
  #//if \MMU_MODE is Sv48, then jump to switch to Sv39
  li x10, 0x9 
  beq x9, x10, 2f
  
  #//if current mode is not supported, then exit
  j 3f 

#//switch to Sv39
1:
  csrr  x9,  satp
  li	x10, 0x0ffff00000000000
  and   x9,x9,x10       #clr SATP.MODE, keep SATP.ASID
  li    x10, 0x100000   #Sv39 ppn 
  li    x11, 0x8000000000000000 #Sv39 mode
  or    x10, x10,x11    
  or    x9, x10,x9
  csrw	satp,x9
  j 3f 
 
#//switch to Sv48
2:
  csrr  x9,  satp
  li	x10, 0x0ffff00000000000
  and   x9,x9,x10        #clr SATP.MODE, keep SATP.ASID
  li    x10, 0x6000000   #Sv48 ppn 
  li    x11, 0x9000000000000000 #Sv48 mode
  or    x10, x10,x11
  or    x9, x10,x9
  csrw	satp,x9
  j 3f
  
3:
  sfence.vma 
  #//restore regs
  ld	x9, 0(x2)
  ld	x10, 8(x2)
  ld	x11, 16(x2)
  addi	x2, x2, 24
  # fence 
.endm


#//---------------6. SWITCH MMU_MODE to Sv48---------------//
.macro SWITCH_TO_SV48
  #//backup regs
  addi	x2, x2, -24
  sd	x9, 0(x2)
  sd	x10, 8(x2)
  sd	x11, 16(x2)

  #//switch to Sv48
  csrr  x9,  satp
  li	x10, 0x0ffff00000000000
  and   x9,x9,x10        #clr SATP.MODE, keep SATP.ASID
  li    x10, 0x6000000   #Sv48 ppn 
  li    x11, 0x9000000000000000 #Sv48 mode
  or    x10, x10,x11
  or    x9, x10,x9
  csrw	satp,x9
  
  sfence.vma 
  #//restore regs
  ld	x9, 0(x2)
  ld	x10, 8(x2)
  ld	x11, 16(x2)
  addi	x2, x2, 24
  # fence 
.endm


#//---------------7. SWITCH MMU_MODE to Sv39---------------//
.macro SWITCH_TO_SV39
  #//backup regs
  addi	x2, x2, -24
  sd	x9, 0(x2)
  sd	x10, 8(x2)
  sd	x11, 16(x2)

  #//switch to Sv39
  csrr  x9,  satp
  li	x10, 0x0ffff00000000000
  and   x9,x9,x10       #clr SATP.MODE, keep SATP.ASID
  li    x10, 0x100000   #Sv39 ppn 
  li    x11, 0x8000000000000000 #Sv39 mode
  or    x10, x10,x11
  or    x9, x10,x9
  csrw	satp,x9
  
  sfence.vma 
  #//restore regs
  ld	x9, 0(x2)
  ld	x10, 8(x2)
  ld	x11, 16(x2)
  addi	x2, x2, 24
  # fence 
.endm


#//---------------8. Prcocess PTW_4K: set {SVPBMT,PPN,FLAG} to level3-page PTE in SV39/level4-page PTE in SV39---------------//
.macro MMU_PTW_4K VPN, PPN, FLAG, SVPBMT
  #//backup regs 
  addi	x2, x2, -88
  sd	x9, 0(x2)
  sd	x10, 8(x2)
  sd	x11, 16(x2)
  sd	x12, 24(x2)
  sd	x13, 32(x2)
  sd	x14, 40(x2)
  sd	x15, 48(x2)
  sd	x16, 56(x2)
  sd	x17, 64(x2)
  sd	x18, 72(x2)
  sd	x19, 80(x2)

  #//if SATP.Mode is Sv48, then jump to SV48 PTW_4K, otherwise process SV39 PTW_4K
  csrr x9, satp
  li x10,0x1000000000000000
  and x9,x9,x10
  bnez x9, 1f  
 
#////SV39 MMU PTW_4K////
  #//get PPN from satp in x9
  csrr  x9, satp
  li    x10, 0xfffffffffff
  and   x9, x9, x10
  
  #//get VPN2 in x10
  li    x10, \VPN
  li    x11, 0x7fc0000
  and   x10,x10,x11
  srli  x10, x10, 18    
   
  #//cfig first-level page
  # level-1 page, entry addr:{satp.PPN,VPN2,3'b0} in x15
  slli  x14, x9, 12
  slli  x11, x10, 3
  add   x15, x14, x11
  # write pte into level-1 page
  # level-2 base addr in x12: satp.ppn + VPN2 + 1
  addi  x12, x10, 1
  add   x12, x12, x9
  slli  x14, x12, 10
  li    x13, 0xc1         #cfig level-2 page properties
  or    x13, x13, x14     #PTE{base addr, properties} in x13: base addr is PTE.ppn, properties is PTE[9:0]
  sd    x13, 0(x15)
  
  #//cfig level-2 page
  #//get VPN1 in x16
  li    x11, \VPN
  li    x13, 0x3fe00
  and   x16, x11, x13
  srli  x16, x16, 9  #x16 = VPN1  
  # level-2 page, entry addr:{pte.ppn,VPN1,3'b0} in x17
  slli  x13, x12, 12
  slli  x17, x16, 3
  add   x17, x17, x13  #x17 {level1-page pte.ppn, VPN1, 3'b0}
  # write pte into level-2 page
  # level-3 base addr in x18: PPN+1+2^9+{vpn2,vpn1}
  li    x11, 0x7ffffff
  li    x10, \VPN
  and   x10, x11,x10
  li    x11, 0x200
  addi  x11, x11, 1
  add   x11, x11, x9  
  srli  x10, x10, 9
  add   x18, x11, x10
  slli  x19, x18, 10 
  li    x13, 0xc1
  or    x19, x19, x13
  sd    x19, 0(x17)
  
  #//cfig level-3 page
  # get VPN0 in x12
  li    x11, \VPN
  li    x12, 0x1ff
  and   x12, x12, x11
  # get level-3 page addr x17
  slli  x18, x18, 12
  slli  x12, x12, 3
  add   x17, x18, x12          #x17 = {level2-page pte.ppn,vpn0,3'b0}
  # write pte into level-3 page
  li    x11, \PPN
  li    x12, \SVPBMT
  li    x13, \FLAG
  slli  x11, x11, 10
  slli  x12, x12, 61
  or    x11, x11, x12
  or    x11, x11, x13
  sd    x11, 0(x17)
  j 2f 

1:
#////SV48 MMU PTW_4K////
  csrr  x9, satp
  li    x10, 0xfffffffffff
  and   x9, x9, x10

  #//get VPN3 in x10
  li    x10, \VPN
  li    x11, 0xff8000000
  and   x10,x10,x11
  srli  x10, x10, 27    
   
  #//cfig first-level page
  # level-1 page, entry addr:{ppn,VPN3,3'b0} in x15
  slli  x14, x9, 12
  slli  x11, x10, 3
  add   x15, x14, x11   #first page entry address
  # write pte into level-1 page
  # level-1 base addr in x12
  addi  x12, x10, 1
  add   x12, x12, x9    # level2 ppn 
  slli  x14, x12, 10
  li    x13, 0xc1
  or    x13, x13, x14
  sd    x13, 0(x15)
  
  #//cfig level-2 page
  # get VPN2 in x16
  li    x11, \VPN
  li    x13, 0x7fc0000
  and   x16, x11, x13
  srli  x16, x16, 18  
  # level-2 page, entry addr:{pte.ppn,VPN2,3'b0} in x17
  slli  x13, x12, 12
  slli  x17, x16, 3
  add   x17, x17, x13            #second page entry address
  # write pte into level-2 page
  # level-3 base addr in x18: PPN+1+2^9+{vpn3,vpn2}

  li    x10, \VPN
  li    x11, 0xfffffffff
  and   x10, x10,x11
  li    x11, 0x200
  addi  x11, x11, 1
  add   x11, x11, x9  
  srli  x10, x10, 18
  add   x18, x11, x10    #level 3 ppn
  slli  x19, x18, 10 
  li    x13, 0xc1
  or    x19, x19, x13
  sd    x19, 0(x17)

  #//cfig level-3 page
  # get VPN1 in x16
  li    x11, \VPN
  li    x13, 0x3fe00
  and   x16, x11, x13
  srli  x16, x16, 9  
  # level-3 page, entry addr:{pte.ppn,VPN1,3'b0} in x17
  slli  x13, x18, 12
  slli  x17, x16, 3
  add   x17, x17, x13  #third page entry address

  #//write pte into level-3 page
  # level-4 base addr in x18: PPN+1+2^9 + 2^9 *2^9 +{vpn3,vpn2,vpn1}
  li    x11, 0x200
  li    x12, 0x40000
  add   x11,x12,x11
  addi  x11, x11,0x1
  add   x11, x11,x9
  li    x12, \VPN
  li    x13, 0xfffffffff
  and   x12, x13,x12
  srli  x12, x12, 9
  add   x12, x12, x11  #level 4 ppn
  slli  x16, x12,10
  li    x13, 0xc1
  or    x13, x16,x13
  sd    x13, 0(x17)
  
  #//get level-4 page addr x17
  li    x11, \VPN
  li    x13, 0x1ff
  and   x16, x11, x13
  slli  x15, x12, 12
  slli  x17, x16, 3
  add   x17,x17,x15

  #//write ppn and flag  
  li    x11, \PPN
  li    x12, \SVPBMT
  li    x13, \FLAG
  slli  x11, x11, 10
  slli  x12, x12, 61
  or    x11, x11, x12
  or    x11, x11, x13
  sd    x11, 0(x17) 

2:
  #//restore regs
  ld	x9, 0(x2)
  ld	x10, 8(x2)
  ld	x11, 16(x2)
  ld	x12, 24(x2)
  ld	x13, 32(x2)
  ld	x14, 40(x2)
  ld	x15, 48(x2)
  ld	x16, 56(x2)
  ld	x17, 64(x2)
  ld	x18, 72(x2)
  ld	x19, 80(x2)
  addi	x2, x2, 88
  # fence 
  fence
.endm


#//---------------9. Prcocess PTW_2M: set {SVPBMT,PPN,FLAG} to level2-page PTE in SV39/level3-page PTE in SV39---------------//
.macro MMU_PTW_2M VPN, PPN, FLAG, SVPBMT
  #//backup regs 
  addi	x2, x2, -88
  sd	x9, 0(x2)
  sd	x10, 8(x2)
  sd	x11, 16(x2)
  sd	x12, 24(x2)
  sd	x13, 32(x2)
  sd	x14, 40(x2)
  sd	x15, 48(x2)
  sd	x16, 56(x2)
  sd	x17, 64(x2)
  sd	x18, 72(x2)
  sd	x19, 80(x2)
  
  #//if SATP.Mode is Sv48, then jump to SV48 PTW_2M, otherwise process SV39 PTW_2M
  csrr x9, satp
  li x10,0x1000000000000000
  and x9,x9,x10
  bnez x9, 1f

#////SV39 MMU PTW_2M////   
  #//get PPN from satp in x9
  csrr  x9, satp
  li    x10, 0xfffffffffff
  and   x9, x9, x10
  
  #//get VPN2 in x10
  li    x10, \VPN
  li    x11, 0x7fc0000
  and   x10,x10,x11
  srli  x10, x10, 18    
   
  #//cfig first-level page
  # level-1 page, entry addr:{ppn,VPN2,3'b0} in x15
  slli  x14, x9, 12
  slli  x11, x10, 3
  add   x15, x14, x11
  # write pte into level-1 page
  # level-2 base addr in x12
  addi  x12, x10, 1
  add   x12, x12, x9
  slli  x14, x12, 10
  li    x13, 0xc1
  or    x13, x13, x14
  sd    x13, 0(x15)
  
  #//cfig level-2 page
  # get VPN1 in x16
  li    x11, \VPN
  li    x13, 0x3fe00
  and   x16, x11, x13
  srli  x16, x16, 9  
  # level-2 page, entry addr:{pte.ppn,VPN1,3'b0} in x17
  slli  x13, x12, 12
  slli  x17, x16, 3
  add   x17, x17, x13

  #//write pte into level-2 page
  li    x11, \PPN
  li    x12, \SVPBMT
  li    x13, \FLAG
  slli  x11, x11, 10
  slli  x12, x12, 61
  or    x11, x11, x12
  or    x11, x11, x13
  sd    x11, 0(x17)
  j 2f #to restore gpr
 
1:
#////SV48 MMU PTW_2M////
  csrr  x9, satp
  li    x10, 0xfffffffffff
  and   x9, x9, x10
  
  #//get VPN3 in x10
  li    x10, \VPN
  li    x11, 0xff8000000
  and   x10,x10,x11
  srli  x10, x10, 27    
   
  #//cfig first-level page
  # level-1 page, entry addr:{ppn,VPN3,3'b0} in x15
  slli  x14, x9, 12
  slli  x11, x10, 3
  add   x15, x14, x11
  # write pte into level-1 page
  # level-2 base addr in x12
  addi  x12, x10, 1
  add   x12, x12, x9
  slli  x14, x12, 10
  li    x13, 0xc1
  or    x13, x13, x14
  sd    x13, 0(x15)
  
  #//cfig level-2 page
  # get VPN2 in x16
  li    x11, \VPN
  li    x13, 0x7fc0000
  and   x16, x11, x13
  srli  x16, x16, 18  
  # level-2 page, entry addr:{pte.ppn,VPN2,3'b0} in x17
  slli  x13, x12, 12
  slli  x17, x16, 3
  add   x17, x17, x13

  #//write pte into level-2 page
  # level-3 base addr in x18: PPN+1+2^9+{vpn3,vpn2}
  li    x10, \VPN
  li    x11, 0x7ffffff
  and   x10, x10,x11
  li    x11, 0x200
  addi  x11, x11, 1
  add   x11, x11, x9  
  srli  x10, x10, 18
  add   x18, x11, x10
  slli  x19, x18, 10 
  li    x13, 0xc1
  or    x19, x19, x13
  sd    x19, 0(x17)
  
  #//cfig level-3 page
  # get VPN1 in x12
  li    x11, \VPN
  li    x12, 0x3fe00
  and   x12, x12, x11
  srli  x12, x12, 9
  # get level-3 page addr x17
  slli  x18, x18, 12
  slli  x12, x12, 3
  add   x17, x18, x12
  # write pte into level-3 page
  li    x11, \PPN
  li    x12, \SVPBMT
  li    x13, \FLAG
  slli  x11, x11, 10
  slli  x12, x12, 61
  or    x11, x11, x12
  or    x11, x11, x13
  sd    x11, 0(x17)

  #//restore regs
2:
  ld	x9, 0(x2)
  ld	x10, 8(x2)
  ld	x11, 16(x2)
  ld	x12, 24(x2)
  ld	x13, 32(x2)
  ld	x14, 40(x2)
  ld	x15, 48(x2)
  ld	x16, 56(x2)
  ld	x17, 64(x2)
  ld	x18, 72(x2)
  ld	x19, 80(x2)
  addi	x2, x2, 88
  # fence 
  fence
.endm


#//---------------10. Prcocess PTW_1G: set {SVPBMT,PPN,FLAG} to level1-page PTE in SV39/level2-page PTE in SV39---------------//
.macro MMU_PTW_1G VPN, PPN, FLAG, SVPBMT
  #//backup regs 
  addi	x2, x2, -88
  sd	x9, 0(x2)
  sd	x10, 8(x2)
  sd	x11, 16(x2)
  sd	x12, 24(x2)
  sd	x13, 32(x2)
  sd	x14, 40(x2)
  sd	x15, 48(x2)
  sd	x16, 56(x2)
  sd	x17, 64(x2)
  sd	x18, 72(x2)
  sd	x19, 80(x2)
  
  #//if SATP.Mode is Sv48, then jump to SV48 PTW_1G, otherwise process SV39 PTW_1G
  csrr x9, satp
  li x10,0x1000000000000000
  and x9,x9,x10
  bnez x9, 1f

#////SV39 MMU PTW_1G//// 
  #//get PPN from satp in x9
  csrr  x9, satp
  li    x10, 0xfffffffffff
  and   x9, x9, x10
  
  #//get VPN2 in x10
  li    x10, \VPN
  li    x11, 0x7fc0000
  and   x10,x10,x11
  srli  x10, x10, 18    
   
  #//cfig first-level page
  # level-1 page, entry addr:{ppn,VPN2,3'b0} in x15
  slli  x14, x9, 12
  slli  x11, x10, 3
  add   x15, x14, x11
  #//write pte into level-1 page
  li    x11, \PPN
  li    x12, \SVPBMT
  li    x13, \FLAG
  slli  x11, x11, 10
  slli  x12, x12, 61
  or    x11, x11, x12
  or    x11, x11, x13
  sd    x11, 0(x15)
  j 2f #jump to restore

   
#////SV48 MMU PTW_1G////
1:
  #//get PPN from satp in x9
  csrr  x9, satp
  li    x10, 0xfffffffffff
  and   x9, x9, x10
  
  #//get VPN2 in x10
  li    x10, \VPN
  li    x11, 0xff8000000
  and   x10,x10,x11
  srli  x10, x10, 27    
   
  #//cfig first-level page
  # level-1 page, entry addr:{ppn,VPN3,3'b0} in x15
  slli  x14, x9, 12
  slli  x11, x10, 3
  add   x15, x14, x11
  #//write pte into level-1 page
  # level-2 base addr in x12
  addi  x12, x10, 1
  add   x12, x12, x9
  slli  x14, x12, 10
  li    x13, 0xc1
  or    x13, x13, x14
  sd    x13, 0(x15)
  
  #//cfig level-2 page
  # get VPN1 in x16
  li    x11, \VPN
  li    x13, 0x7fc0000
  and   x16, x11, x13
  srli  x16, x16, 18
  # level-2 page, entry addr:{pte.ppn,VPN2,3'b0} in x17
  slli  x13, x12, 12
  slli  x17, x16, 3
  add   x17, x17, x13
  #//write pte into level-2 page
  li    x11, \PPN
  li    x12, \SVPBMT
  li    x13, \FLAG
  slli  x11, x11, 10
  slli  x12, x12, 61
  or    x11, x11, x12
  or    x11, x11, x13
  sd    x11, 0(x17)

  #//restore regs
2:
  ld	x9, 0(x2)
  ld	x10, 8(x2)
  ld	x11, 16(x2)
  ld	x12, 24(x2)
  ld	x13, 32(x2)
  ld	x14, 40(x2)
  ld	x15, 48(x2)
  ld	x16, 56(x2)
  ld	x17, 64(x2)
  ld	x18, 72(x2)
  ld	x19, 80(x2)
  addi	x2, x2, 88
  # fence 
  fence
.endm


#//---------------11. Prcocess PTW_512G: set {SVPBMT,PPN,FLAG} to level1-page PTE in SV48---------------//
.macro MMU_PTW_512G VPN, PPN, FLAG, SVPBMT
  #//backup regs 
  addi	x2, x2, -56
  sd	x9, 0(x2)
  sd	x10, 8(x2)
  sd	x11, 16(x2)
  sd	x12, 24(x2)
  sd	x13, 32(x2)
  sd	x14, 40(x2)
  sd	x15, 48(x2)
  
  #//get PPN from satp in x9
  csrr  x9, satp
  li    x10, 0xfffffffffff
  and   x9, x9, x10
  
  #//get VPN3 in x10
  li    x10, \VPN
  li    x11, 0xff8000000
  and   x10,x10,x11
  srli  x10, x10, 27    
   
  #//cfig first-level page
  # level-1 page, entry addr:{ppn,VPN3,3'b0} in x15
  slli  x14, x9, 12
  slli  x11, x10, 3
  add   x15, x14, x11
  # write pte into level-1 page
  li    x11, \PPN
  li    x12, \SVPBMT
  li    x13, \FLAG
  slli  x11, x11, 10
  slli  x12, x12, 61
  or    x11, x11, x12
  or    x11, x11, x13
  sd    x11, 0(x15)
  
  #//restore regs
  ld	x9, 0(x2)
  ld	x10, 8(x2)
  ld	x11, 16(x2)
  ld	x12, 24(x2)
  ld	x13, 32(x2)
  ld	x14, 40(x2)
  ld	x15, 48(x2)
  addi	x2, x2, 56
  # fence 
  fence
.endm


#//---------------12. SET SMIR = {48'b0, INDEX}, INDEX = {iutlb,dutlb,4'b0,index}---------------//
.macro MMU_W_MIR INDEX
  #backup regs
  addi	x2, x2, -8
  sd	x9, 0(x2)

  #write {48'b0, INDEX} to MIR
  li	x9, \INDEX
  csrw	smir, x9

  #restore regs
  ld	x9, 0(x2)
  addi	x2, x2, 8
.endm


#//---------------13. SET SMEL = {CSKYFLAG, PMPFLAG, PFN, FLAG}---------------//
.macro MMU_W_MEL PFN, PMPFLAG, FLAG, CSKYFLAG
  #backup regs
  addi	x2, x2, -32
  sd	x9, 0(x2)
  sd	x10, 8(x2)
  sd	x11, 16(x2)
  sd	x12, 24(x2)

  #write {CSKYFLAG, PMPFLAG,PFN , FLAG} to MEL
  li	x9, \CSKYFLAG
  slli	x9, x9, 59
  li    x10, \PMPFLAG
  slli  x10,x10,55

  li	x11, \PFN
  slli	x11, x11, 10
  li	x12, \FLAG
  or	x9, x9, x10
  or	x9, x9, x11
  or	x9, x9, x12
  csrw	smel, x9

  #restore regs
  ld	x12, 24(x2)
  ld	x11, 16(x2)
  ld	x10, 8(x2)
  ld	x9, (x2)
  addi	x2, x2, 32
.endm


#//---------------14. SET SMEL = {CSKYFLAG, PMPFLAG, PFN, FLAG} using reg---------------//
.macro MMU_W_MEL_REG PFN_REG, PMPFLAG_REG,FLAG_REG, CSKYFLAG_REG
  #backup regs
  addi	x2, x2, -32
  sd	\PFN_REG, 0(x2)
  sd    \PMPFLAG_REG, 8(x2)
  sd	\CSKYFLAG_REG, 16(x2)
  sd	\FLAG_REG, 24(x2)

  #write {CSKYFLAG, PMPFLAG,PFN , FLAG} to MEL
  slli	\CSKYFLAG_REG, \CSKYFLAG_REG, 59
  slli  \PMPFLAG_REG, \PMPFLAG_REG, 55
  slli	\PFN_REG, \PFN_REG, 10
  or	\PFN_REG, \PFN_REG, \PMPFLAG_REG
  or	\PFN_REG, \PFN_REG, \CSKYFLAG_REG
  or	\FLAG_REG, \PFN_REG, \FLAG_REG
  csrw	smel, \FLAG_REG

  #restore regs
  ld	\PFN_REG, 0(x2)
  ld	\PMPFLAG_REG, 8(x2)
  ld	\CSKYFLAG_REG, 16(x2)
  ld	\FLAG_REG, 24(x2)
  addi	x2, x2, 32
.endm


#//---------------15. SET SMEH = {PAGESIZE[3],VPN,PAGESIZE[2:0],ASID}---------------//
.macro MMU_W_MEH VPN, PAGESIZE, ASID
  #//backup regs
  addi	x2, x2, -24
  sd	x9, 0(x2)
  sd	x10, 8(x2)
  sd	x11, 16(x2)

  #//write {PAGESIZE[3],VPN,PAGESIZE[2:0],ASID} to MEH
  li	x9, \PAGESIZE
  li    x10, 0x7
  and   x9, x9,x10
  slli x9,x9,16            #x9={45'b0, PAGESIZE[2:0], 16'b0}
  li	x10, \PAGESIZE
  srli  x10,x10,3
  slli  x10,x10,63         #x10={PAGESIZE[3], 63'b0}
  or    x9, x9,x10         #x9={PAGESIZE[3],44'b0, PAGESIZE[2:0], 16'b0}
  li	x10, \VPN
  slli	x10, x10, 19       #x10={VPN, 19'b0}
  li	x11, \ASID         #x11={48'b0,ASID}
  or	x9, x9, x10
  or	x9, x9, x11
  csrw	smeh,x9

  #//restore regs
  ld	x11, 16(x2)
  ld	x10, 8(x2)
  ld	x9, (x2)
  addi	x2, x2, 24
.endm


#//---------------16. SET SMEH = {PAGESIZE[3],VPN,PAGESIZE[2:0],ASID} using reg---------------//
.macro MMU_W_MEH_REG VPN_REG, PAGESIZE_REG, ASID_REG
  #//backup regs
  addi	x2, x2, -24
  sd	\VPN_REG, 0(x2)
  sd	\PAGESIZE_REG, 8(x2)
  sd	\ASID_REG, 16(x2)

  #//write {PAGESIZE[3],VPN,PAGESIZE[2:0],ASID} to MEH
  li   \VPN_REG ,0x7
  and  \VPN_REG, \PAGESIZE_REG,\VPN_REG
  slli \VPN_REG, \VPN_REG, 16
  srli \PAGESIZE_REG,\PAGESIZE_REG,3
  slli \PAGESIZE_REG,\PAGESIZE_REG,63
  or   \PAGESIZE_REG,\PAGESIZE_REG,\VPN_REG

  ld    \VPN_REG,0(x2)  #restore first
  slli	\VPN_REG, \VPN_REG, 19
  or	\ASID_REG, \ASID_REG, \PAGESIZE_REG
  or	\ASID_REG, \ASID_REG, \VPN_REG
  csrw	smeh,\ASID_REG

  #//restore regs
  ld	\PAGESIZE_REG, 8(x2)
  ld	\ASID_REG, 16(x2)
  addi	x2, x2, 24
.endm


#//---------------17. SET SMEH = {PAGESIZE[3], ZONEID, VPN,PAGESIZE[2:0],ASID} using reg---------------//
.macro MMU_W_MEH_REG_TEE VPN_REG, PAGESIZE_REG, ASID_REG, ZONEID_REG
  #backup regs
  addi	x2, x2, -24
  sd	\VPN_REG, 0(x2)
  sd	\PAGESIZE_REG, 8(x2)
  sd	\ASID_REG, 16(x2)

  #//write {PAGESIZE[3], ZONEID, VPN,PAGESIZE[2:0],ASID} to MEH
  li   \VPN_REG ,0x7
  and  \VPN_REG, \PAGESIZE_REG,\VPN_REG
  slli \VPN_REG, \VPN_REG, 16
  srli \PAGESIZE_REG,\PAGESIZE_REG,3
  slli \PAGESIZE_REG,\PAGESIZE_REG,63
  or   \PAGESIZE_REG,\PAGESIZE_REG,\VPN_REG

  ld    \VPN_REG,0(x2)  #restore first
  slli	\VPN_REG, \VPN_REG, 19
  or	\ASID_REG, \ASID_REG, \PAGESIZE_REG
  or	\ASID_REG, \ASID_REG, \VPN_REG
  slli  \VPN_REG, \ZONEID_REG,59
  or    \ASID_REG, \ASID_REG, \VPN_REG
  csrw	smeh,\ASID_REG

  #restore regs
  ld	\VPN_REG, 0(x2)
  ld	\PAGESIZE_REG, 8(x2)
  ld	\ASID_REG, 16(x2)
  addi	x2, x2, 24
.endm


#//---------------18. SET SMCIR.TLBP = 1'b1---------------//
.macro MMU_E_P
  #backup regs
  addi	x2, x2, -8
  sd	x9, 0(x2)

  #enable TLBP
  li	x9, 0x80000000 
  csrw	smcir,x9

  #restore regs
  ld	x9, 0(x2)
  addi	x2, x2, 8
.endm


#//---------------19. SET SMCIR.TLBR = 1'b1---------------//
.macro MMU_E_R
  #backup regs
  addi	x2, x2, -8
  sd	x9, 0(x2)

  #enable TLBR
  li	x9, 0x40000000 
  csrw	smcir,x9

  #restore regs
  ld	x9, 0(x2)
  addi	x2, x2, 8
.endm


#//---------------20. SET SMCIR.TLBWI = 1'b1---------------//
.macro MMU_E_WI
  #backup regs
  addi	x2, x2, -8
  sd	x9, 0(x2)

  #enable TLBWI
  li	x9, 0x20000000 
  csrw	smcir,x9

  #restore regs
  ld	x9, 0(x2)
  addi	x2, x2, 8
.endm


#//---------------21. SET SMCIR.TLBWR = 1'b1---------------//
.macro MMU_E_WR
  #backup regs
  addi	x2, x2, -8
  sd	x9, 0(x2)

  #enable TLBWR
  li	x9, 0x10000000 
  csrw	smcir,x9

  #restore regs
  ld	x9, 0(x2)
  addi	x2, x2, 8
.endm


#//---------------22. SET SMCIR.IASID = 1'b1 & SMCIR.ASID = ASID---------------//
.macro MMU_E_INV ASID
  #backup regs
  addi	x2, x2, -16
  sd	x9, 0(x2)
  sd	x10, 8(x2)

  #enable TLBIASID
  li	x9, 0x08000000 
  li	x10, \ASID
  or    x9,x9,x10 
  csrw	smcir,x9

  #restore regs
  ld	x9, 0(x2)
  ld	x10, 8(x2)
  addi	x2, x2, 16
.endm


#//---------------23. SET SMCIR.IALL = 1'b1---------------//
.macro MMU_E_INV_ALL
  #backup regs
  addi	x2, x2, -8
  sd	x9, 0(x2)

  #enable TLBIALL
  li	x9, 0x04000000 
  csrw	smcir,x9

  #restore regs
  ld	x9, 0(x2)
  addi	x2, x2, 8
.endm


#//---------------24. INVALID the TLB with TLBINDEX---------------//
.macro MMU_E_INVI TLBINDEX
  #//backup regs
  addi	x2, x2, -16
  sd	x9, 0(x2)
  sd	x10, 8(x2)

  #//write smir_INDEX
  li	x9, \TLBINDEX
  csrw	smir,x9
  
  #enable TLBII
  li	x10, 0x02000000 
  csrw	smcir,x10

  #//restore regs
  ld	x10, 8(x2)
  ld	x9, (x2)
  addi	x2, x2, 16
.endm


#//---------------25. SET SMCIR.??---------------//
.macro MMU_E_TINV_ALL
  #backup regs
  addi	x2, x2, -8
  sd	x9, 0(x2)

  #????
  li	x9, 0x01000000 
  csrw	smcir,x9

  #restore regs
  ld	x9, 0(x2)
  addi	x2, x2, 8
.endm


#//---------------26. SET SATP.PPN = PPN---------------//
.macro MMU_SATP_PPN PPN
  #backup regs
  addi	x2, x2, -16
  sd	x9,  0(x2)
  sd	x10, 8(x2)

  #write PPN
  csrr  x9, satp
  li	x10, 0xfffffffff0000000
  and   x9,x9,x10
  li    x10, \PPN
  or    x9,x9,x10
  csrw	satp,x9

  #restore regs
  ld	x10, 8(x2)
  ld	x9,  0(x2)
  addi	x2, x2, 16
.endm


#//---------------27. SET SATP.ASID = ASID---------------//
.macro MMU_SATP_ASID ASID
  #backup regs
 # addi	x2, x2, -16
 # sd	x9,  0(x2)
 # sd	x10, 8(x2)

  #write ASID
  csrr  x9, satp
  li	x10, 0xf0000fffffffffff
  and   x9,x9,x10
  li    x10, \ASID
  slli  x10,x10,44

  or    x9,x9,x10
  csrw	satp,x9

  #restore regs
  #ld	x10, 8(x2)
  #ld	x9,  0(x2)
  #addi	x2, x2, 16
.endm


#//---------------28. SET SATP.ASID = ASID_REG using reg---------------//
.macro MMU_SATP_ASID_REG ASID_REG TMP_REG
  #backup regs
  addi	x2, x2, -16
  sd	\ASID_REG,  0(x2)
  sd	\TMP_REG, 8(x2)

  #write ASID
  csrr  \TMP_REG, satp
  li	\ASID_REG, 0xf0000fffffffffff
  and   \TMP_REG,\TMP_REG,\ASID_REG
  ld   \ASID_REG,0(x2)
  slli  \ASID_REG,\ASID_REG,44

  or    \ASID_REG,\ASID_REG,\TMP_REG
  csrw	satp,\ASID_REG

  #restore regs
  ld	\TMP_REG, 8(x2)
  ld	\ASID_REG,  0(x2)
  addi	x2, x2, 16
.endm


#//---------------29. FLUSH TLB & SET level-1 page PTE = {0xf, 49'b0, 2'b0,0xff} & set mstatus.sum = 1'b1---------------//
.macro RECOVER_MMU
  #flush tlb
  sfence.vma x0,x0

  #backup regs 
  addi	x2, x2, -56
  sd	x9, 0(x2)
  sd	x10, 8(x2)
  sd	x11, 16(x2)
  sd	x12, 24(x2)
  sd	x13, 32(x2)
  sd	x14, 40(x2)
  sd	x15, 48(x2)
   
  # get PPN from satp in x9
  csrr  x9, satp
  li    x10, 0xfffffffffff
  and   x9, x9, x10
  
  # get VPN2 in x10
  li    x10, 0
  li    x11, 0x7fc0000
  and   x10,x10,x11
  srli  x10, x10, 18    
   
  # cfig first-level page
  # level-1 page, entry addr:{ppn,VPN2,3'b0} in x15
  slli  x14, x9, 12
  slli  x11, x10, 3
  add   x15, x14, x11   #x15 = {satp.ppn, vpn2, 3'b0}
  # write pte into level-1 page
  li    x11, 0
  li    x12, 0xf
  li    x13, 0xff
  slli  x11, x11, 10
  slli  x12, x12, 59
  or    x11, x11, x12
  or    x11, x11, x13  #x11 = {0xf,49'b0,2'b0,0xff}
  sd    x11, 0(x15)
  
  li    x9,0x40000
  csrc  mstatus,x9  # mstatus.sum = 1'b0
  csrr  x9,mstatus
  li    x10, 1
  slli  x10,x10,18
  or    x9,x9,x10
  csrw  mstatus,x9  #mstatus.sum = 1'b1

  #restore regs
  ld	x9, 0(x2)
  ld	x10, 8(x2)
  ld	x11, 16(x2)
  ld	x12, 24(x2)
  ld	x13, 32(x2)
  ld	x14, 40(x2)
  ld	x15, 48(x2)
  addi	x2, x2, 56
.endm


#//---------------30. SET MSTATUS.MPRV = IMM---------------//
.macro MSTATUS_MPRV IMM
  #write mprv
  li    x9,0x20000
  csrc  mstatus,x9  #clear MPRV
  csrr  x9,mstatus
  li    x10, \IMM
  slli  x10,x10,17
  or    x9,x9,x10
  csrw  mstatus,x9
.endm


#//---------------31. SET MSTATUS.SUM = IMM---------------//
.macro MSTATUS_SUM IMM
  addi  x2, x2, -16
  sd    x9, 0(x2)
  sd    x10, 8(x2)
  #write sum
  li    x9,0x40000
  csrc  mstatus,x9
 #csrr  x9,mstatus
  li    x10, \IMM
  slli  x10,x10,18
 # or    x9,x9,x10
  csrs  mstatus,x10
  ld   x9,0(x2)
  ld   x10,8(x2)
  addi x2,x2,16
.endm


#//---------------32. SET MSTATUS.MXR = IMM---------------//
.macro MSTATUS_MXR IMM
  addi  x2, x2, -16
  sd    x9, 0(x2)
  sd    x10, 8(x2)
  #write mxr
  li    x9,0x80000
  csrc  mstatus,x9
  csrr  x9,mstatus
  li    x10, \IMM
  slli  x10,x10,19
  or    x9,x9,x10
  csrw  mstatus,x9
  ld   x9,0(x2)
  ld   x10,8(x2)
  addi x2,x2,16
.endm


#//---------------33. SET MSTATUS.TVM = IMM---------------//
.macro MSTATUS_TVM IMM
  addi  x2, x2, -16
  sd    x9, 0(x2)
  sd    x10, 8(x2)
  #write tvm
  li    x9,0x100000
  csrc  mstatus,x9
  csrr  x9,mstatus
  li    x10, \IMM
  slli  x10,x10,20
  or    x9,x9,x10
  csrw  mstatus,x9
  ld   x9,0(x2)
  ld   x10,8(x2)
  addi x2,x2,16
.endm


#//---------------34. SET MSTATUS.MPP = IMM---------------//
.macro MSTATUS_MPP IMM
#  addi  x2, x2, -16
#  sd    x9, 0(x2)
#  sd    x10, 8(x2)
  #write mpp
  li    x9,0x1800
  csrc  mstatus,x9
  csrr  x9,mstatus
  li    x10, \IMM
  slli  x10,x10,11
  or    x9,x9,x10
  csrw  mstatus,x9
#  ld   x9,0(x2)
#  ld   x10,8(x2)
#  addi x2,x2,16
.endm


#//---------------35. SET MXSTATUS.MAEE = IMM---------------//
.macro MXSTATUS_MAEE IMM
  addi  x2, x2, -16
  sd    x9, 0(x2)
  sd    x10, 8(x2)
  #write maee
  li    x9,0x200000
  csrc  mxstatus,x9
  csrr  x9,mxstatus
  li    x10, \IMM
  slli  x10,x10,21
  or    x9,x9,x10
  csrw  mxstatus,x9
  ld   x9,0(x2)
  ld   x10,8(x2)
  addi x2,x2,16
.endm


#//---------------36. SET MXSTATUS.MHRD = IMM---------------//
.macro MXSTATUS_MHRD IMM
  addi  x2, x2, -16
  sd    x9, 0(x2)
  sd    x10, 8(x2)
  #write mhrd
  li    x9,0x40000
  csrc  mxstatus,x9
  csrr  x9,mxstatus
  li    x10, \IMM
  slli  x10,x10,18
  or    x9,x9,x10
  csrw  mxstatus,x9
  ld   x9,0(x2)
  ld   x10,8(x2)
  addi x2,x2,16
.endm


#//---------------37. SET MXSTATUS_CSKYISAEE = IMM---------------//
.macro MXSTATUS_CSKYISAEE IMM
  addi  x2, x2, -16
  sd    x9, 0(x2)
  sd    x10, 8(x2)
  #write cskyisaee
  li    x9,0x400000
  csrc  mxstatus,x9
  csrr  x9,mxstatus
  li    x10, \IMM
  slli  x10,x10,22
  or    x9,x9,x10
  csrw  mxstatus,x9
  ld   x9,0(x2)
  ld   x10,8(x2)
  addi x2,x2,16
.endm


#//---------------38. SET MXSTATUS.MM = IMM---------------//
.macro MXSTATUS_MM IMM
  addi  x2, x2, -16
  sd    x9, 0(x2)
  sd    x10, 8(x2)
  #write misalign enable
  li    x9,0x8000
  csrc  mxstatus,x9
  csrr  x9,mxstatus
  li    x10, \IMM
  slli  x10,x10,15
  or    x9,x9,x10
  csrw  mxstatus,x9
  ld   x9,0(x2)
  ld   x10,8(x2)
  addi x2,x2,16
.endm


#//---------------39. MXSTATUS.UCME = IMM---------------//
.macro MXSTATUS_UCME IMM
  addi  x2, x2, -16
  sd    x9, 0(x2)
  sd    x10, 8(x2)
  #write ucme
  li    x9,0x10000
  csrc  mxstatus,x9
  csrr  x9,mxstatus
  li    x10, \IMM
  slli  x10,x10,16
  or    x9,x9,x10
  csrw  mxstatus,x9
  ld   x9,0(x2)
  ld   x10,8(x2)
  addi x2,x2,16
.endm


#//---------------40. MXSTATUS.INSDE = IMM---------------//
.macro MXSTATUS_INSDE IMM
  #write isnde
  li    x9,0x80000
  csrc  mxstatus,x9
  csrr  x9,mxstatus
  li    x10, \IMM
  slli  x10,x10,19
  or    x9,x9,x10
  csrw  mxstatus,x9
.endm


#//---------------41. SET MXSTATUS.CLINTEE = IMM---------------//
.macro MXSTATUS_CLINTEE IMM
  #write CLINTaee
  li    x9,0x20000
  csrc  mxstatus,x9
  csrr  x9,mxstatus
  li    x10, \IMM
  slli  x10,x10,17
  or    x9,x9,x10
  csrw  mxstatus,x9
.endm


#//---------------42. SET MXSTATUS.FCCEE = IMM ??---------------//
.macro MXSTATUS_FCCEE IMM
  #write fccee
  li    x9,0x100000
  csrc  mxstatus,x9
  csrr  x9,mxstatus
  li    x10, \IMM
  slli  x10,x10,20
  or    x9,x9,x10
  csrw  mxstatus,x9
.endm


#//---------------43. SET MENVCFG_PBMTE = IMM---------------//
.macro MENVCFG_PBMTE IMM
  #write pbmte
  li    x9,0x1
  slli  x9, x9, 62
  csrc  menvcfg,x9
  csrr  x9,menvcfg
  li    x10, \IMM
  slli  x10,x10,62
  or    x9,x9,x10
  csrw  menvcfg,x9
.endm


#//---------------44. SET FXCR_DQNaN = IMM---------------//
.macro FXCR_DQNaN IMM
  #write DQNaN
  li    x9,0x200000
  csrc  fxcr,x9
  csrr  x9,fxcr
  li    x10, \IMM
  slli  x10,x10,23
  or    x9,x9,x10
  csrw  fxcr,x9
.endm


#//---------------45. SET PMPCFG.entry0_cfg = IMM---------------//
.macro PMPCFG0_0 IMM
  #write pmpcfg0_0
  li    x9,0xff
  csrc  pmpcfg0,x9
  csrr  x9,pmpcfg0
  li    x10, \IMM
  slli  x10,x10,0
  or    x9,x9,x10
  csrw  pmpcfg0,x9
  sfence.vma x0,x0
.endm


#//---------------46. SET PMPCFG.entry1_cfg = IMM---------------//
.macro PMPCFG0_1 IMM
  #write pmpcfg0_1
  li    x9,0xff00
  csrc  pmpcfg0,x9
  csrr  x9,pmpcfg0
  li    x10, \IMM
  slli  x10,x10,8
  or    x9,x9,x10
  csrw  pmpcfg0,x9
  sfence.vma x0,x0
.endm


#//---------------47. SET PMPCFG.entry2_cfg = IMM---------------//
.macro PMPCFG0_2 IMM
  #write pmpcfg0_2
  li    x9,0xff0000
  csrc  pmpcfg0,x9
  csrr  x9,pmpcfg0
  li    x10, \IMM
  slli  x10,x10,16
  or    x9,x9,x10
  csrw  pmpcfg0,x9
  sfence.vma x0,x0
.endm


#//---------------48. SET PMPCFG.entry3_cfg = IMM---------------//
.macro PMPCFG0_3 IMM
  #write pmpcfg0_3
  li    x9,0xff000000
  csrc  pmpcfg0,x9
  csrr  x9,pmpcfg0
  li    x10, \IMM
  slli  x10,x10,24
  or    x9,x9,x10
  csrw  pmpcfg0,x9
  sfence.vma x0,x0
.endm


#//---------------49. SET PMPCFG.entry4_cfg = IMM---------------//
.macro PMPCFG0_4 IMM
  #write pmpcfg0_4
  li    x9,0xff00000000
  csrc  pmpcfg0,x9
  csrr  x9,pmpcfg0
  li    x10, \IMM
  slli  x10,x10,32
  or    x9,x9,x10
  csrw  pmpcfg0,x9
  sfence.vma x0,x0
.endm


#//---------------50. SET PMPCFG.entry5_cfg = IMM---------------//
.macro PMPCFG0_5 IMM
  #write pmpcfg0_5
  li    x9,0xff0000000000
  csrc  pmpcfg0,x9
  csrr  x9,pmpcfg0
  li    x10, \IMM
  slli  x10,x10,40
  or    x9,x9,x10
  csrw  pmpcfg0,x9
  sfence.vma x0,x0
.endm


#//---------------51. SET PMPCFG.entry6_cfg = IMM---------------//
.macro PMPCFG0_6 IMM
  #write pmpcfg0_6
  li    x9,0xff000000000000
  csrc  pmpcfg0,x9
  csrr  x9,pmpcfg0
  li    x10, \IMM
  slli  x10,x10,48
  or    x9,x9,x10
  csrw  pmpcfg0,x9
  sfence.vma x0,x0
.endm


#//---------------52. SET PMPCFG.entry7_cfg = IMM---------------//
.macro PMPCFG0_7 IMM
  #write pmpcfg0_7
  li    x9,0xff00000000000000
  csrc  pmpcfg0,x9
  csrr  x9,pmpcfg0
  li    x10, \IMM
  slli  x10,x10,56
  or    x9,x9,x10
  csrw  pmpcfg0,x9
  sfence.vma x0,x0
.endm


#//---------------53. SET MSTATUS.MPP = 2'b01 MEPC = SROUTINE---------------//
.macro MMU_MMODE_SMODE  SROUTINE
  #write mepc
  addi x2,x2,-16
  sd x1, 0(x2)
  sd x3, 8(x2)
  la x1,\SROUTINE
  csrw mepc,x1
  li x1,0x800
  csrrs x3,mstatus,x1
  li x1,0x1000
  csrrc x3,mstatus,x1
  ld x1, 0(x2)
  ld x3, 8(x2)
  addi x2,x2,16
  mret
.endm


#//---------------54. SET MSTATUS.SPP = 1'b1 SPEC = SROUTINE---------------//
.macro MMU_MMODE_SMODE_S  SROUTINE
  #write sepc
  la x1,\SROUTINE
  csrw sepc,x1
  li x1,0x100
  csrrs x0,mstatus,x1
  sret
.endm


#//---------------55. SET STATUS.SPP = 1'b0 SEPC = UROUTINE---------------//
.macro MMU_SMODE_UMODE  UROUTINE
  #write sepc
  la x1,\UROUTINE
  csrw sepc,x1
  li x1,0x100
  csrrc x3,sstatus,x1
  sret
.endm


#//---------------56. SET MSTATUS.MPP = 2'b0 MEPC = UROUTINE---------------//
.macro MMU_MMODE_UMODE  UROUTINE
  #write mepc
  la x1,\UROUTINE
  csrw mepc,x1
  li x1,0x1800
  csrrc x3,mstatus,x1
  mret
.endm


#//---------------57. SET MSTATUS.SPP = 0 SEPC = UROUTINE---------------//
.macro MMU_MMODE_UMODE_S  UROUTINE
  #write sepc
  la x1,\UROUTINE
  csrw sepc,x1
  li x1,0x100
  csrrc x0,mstatus,x1
  sret
.endm


#//---------------58. Initialize MMU---------------//
.macro MMU_RV32_DEFAULT_INIT
# initialize MMU, s mode instruction fetch cannot access u mode page
MMU_RV32_DEFAULT_INIT:
# VPN:0x0000_0000~0x3fff_ffff,
MMU_PTW_2M 0x0,0x0,0xef,0x0
MMU_PTW_2M 0x200,0x200,0xef,0x0
MMU_PTW_2M 0x400,0x400,0xef,0x0
MMU_PTW_2M 0x600,0x600,0xef,0x0
MMU_PTW_2M 0x800,0x800,0xef,0x0
MMU_PTW_2M 0xa00,0xa00,0xef,0x0
MMU_PTW_2M 0xc00,0xc00,0xef,0x0
MMU_PTW_2M 0xe00,0xe00,0xef,0x0
MMU_PTW_2M 0x1000,0x0,0xff,0x0
MMU_PTW_2M 0x1200,0x200,0xff,0x0
MMU_PTW_2M 0x1400,0x400,0xff,0x0
MMU_PTW_2M 0x1600,0x600,0xff,0x0
MMU_PTW_2M 0x1800,0x800,0xff,0x0
MMU_PTW_2M 0x1a00,0xa00,0xff,0x0
MMU_PTW_2M 0x1c00,0xc00,0xff,0x0
MMU_PTW_2M 0x1e00,0xe00,0xff,0x0

# lxf PA=0x3000 -> 0x2000.
MMU_PTW_2M 0x3000,0x2000,0xff,0x0
MMU_PTW_2M 0x3200,0x2200,0xff,0x0
MMU_PTW_2M 0x3400,0x2400,0xff,0x0
MMU_PTW_2M 0x3600,0x2600,0xff,0x0
MMU_PTW_2M 0x3800,0x2800,0xff,0x0
MMU_PTW_2M 0x3a00,0x2a00,0xff,0x0
MMU_PTW_2M 0x3c00,0x2c00,0xff,0x0
MMU_PTW_2M 0x3e00,0x2e00,0xff,0x0

# invalid all icache & TLB, lxf 20220810.
icache.ialls
sfence.vma x0, x0
#sfence.vmas x0, x0  # finally decide to do not support in C908, 20220811.

.endm


#//---------------59. Get 4K page(napot or not) addr---------------//
.macro MMU_PTW_ADDR_4K VPN, RETREG
  #backup regs 
  #//RETREG should avoid x9~x19
  addi	x2, x2, -88
  sd	x9, 0(x2)
  sd	x10, 8(x2)
  sd	x11, 16(x2)
  sd	x12, 24(x2)
  sd	x13, 32(x2)
  sd	x14, 40(x2)
  sd	x15, 48(x2)
  sd	x16, 56(x2)
  sd	x17, 64(x2)
  sd	x18, 72(x2)
  sd	x19, 80(x2)

  csrr x9, satp
  li x10,0x1000000000000000
  and x9,x9,x10
  bnez x9, 1f  #jump to SV48 PTW 4K 
 
  # get PPN from satp in x9
  csrr  x9, satp
  li    x10, 0xfffffffffff
  and   x9, x9, x10
  
  # get VPN2 in x10
  li    x10, \VPN
  li    x11, 0x7fc0000
  and   x10,x10,x11
  srli  x10, x10, 18    
   
  # cfig first-level page
  # level-1 page, entry addr:{ppn,VPN2,3'b0} in x15
  slli  x14, x9, 12
  slli  x11, x10, 3
  add   x15, x14, x11
  # write pte into level-1 page
  # level-2 base addr in x12
  addi  x12, x10, 1
  add   x12, x12, x9
  slli  x14, x12, 10
  li    x13, 0xc1
  or    x13, x13, x14
  ####sd    x13, 0(x15)
  
  # cfig level-2 page
  # get VPN1 in x16
  li    x11, \VPN
  li    x13, 0x3fe00
  and   x16, x11, x13
  srli  x16, x16, 9  
  # level-2 page, entry addr:{pte.ppn,VPN1,3'b0} in x17
  slli  x13, x12, 12
  slli  x17, x16, 3
  add   x17, x17, x13
  # write pte into level-2 page
  # level-3 base addr in x18: PPN+1+2^9+{vpn2,vpn1}
  li    x11, 0x7ffffff
  li    x10, \VPN
  and   x10, x11,x10
  li    x11, 0x200
  addi  x11, x11, 1
  add   x11, x11, x9  
  srli  x10, x10, 9
  add   x18, x11, x10
  slli  x19, x18, 10 
  li    x13, 0xc1
  or    x19, x19, x13
  ####sd    x19, 0(x17)
  
  # cfig level-3 page
  # get VPN0 in x12
  li    x11, \VPN
  li    x12, 0x1ff
  and   x12, x12, x11
  # get level-3 page addr x17
  slli  x18, x18, 12
  slli  x12, x12, 3
  add   x17, x18, x12
  mv    \RETREG, x17
  # return x17
  j 2f 

 
 
1:
  #SV48 MMU PTW 4K BEG
  csrr  x9, satp
  li    x10, 0xfffffffffff
  and   x9, x9, x10

  # get VPN3 in x10
  li    x10, \VPN
  li    x11, 0xff8000000
  and   x10,x10,x11
  srli  x10, x10, 27    
   
  # cfig first-level page
  # level-1 page, entry addr:{ppn,VPN3,3'b0} in x15
  slli  x14, x9, 12
  slli  x11, x10, 3
  add   x15, x14, x11   #first page entry address
  # write pte into level-1 page
  # level-1 base addr in x12
  addi  x12, x10, 1
  add   x12, x12, x9    # level2 ppn 
  slli  x14, x12, 10
  li    x13, 0xc1
  or    x13, x13, x14
  ####sd    x13, 0(x15)
  
  # cfig level-2 page
  # get VPN2 in x16
  li    x11, \VPN
  li    x13, 0x7fc0000
  and   x16, x11, x13
  srli  x16, x16, 18  
  # level-2 page, entry addr:{pte.ppn,VPN2,3'b0} in x17
  slli  x13, x12, 12
  slli  x17, x16, 3
  add   x17, x17, x13            #second page entry address
  # write pte into level-2 page
  # level-3 base addr in x18: PPN+1+2^9+{vpn3,vpn2}

  li    x10, \VPN
  li    x11, 0xfffffffff
  and   x10, x10,x11
  li    x11, 0x200
  addi  x11, x11, 1
  add   x11, x11, x9  
  srli  x10, x10, 18
  add   x18, x11, x10    #level 3 ppn
  slli  x19, x18, 10 
  li    x13, 0xc1
  or    x19, x19, x13
  ####sd    x19, 0(x17)
  

  # cfig level-3 page
  # get VPN1 in x16
  li    x11, \VPN
  li    x13, 0x3fe00
  and   x16, x11, x13
  srli  x16, x16, 9  
  # level-3 page, entry addr:{pte.ppn,VPN1,3'b0} in x17
  slli  x13, x18, 12
  slli  x17, x16, 3
  add   x17, x17, x13  #third page entry address

  # write pte into level-3 page
  # level-4 base addr in x18: PPN+1+2^9 + 2^9 *2^9 +{vpn3,vpn2,vpn1}
  li    x11, 0x200
  li    x12, 0x40000
  add   x11,x12,x11
  addi  x11, x11,0x1
  add   x11, x11,x9
  li    x12, \VPN
  li    x13, 0xfffffffff
  and   x12, x13,x12
  srli  x12, x12, 9
  add   x12, x12, x11  #level 4 ppn
  slli  x16, x12,10
  li    x13, 0xc1
  or    x13, x16,x13
  ####sd    x13, 0(x17)
  

  # get level-4 page addr x17
  li    x11, \VPN
  li    x13, 0x1ff
  and   x16, x11, x13
  slli  x15, x12, 12
  slli  x17, x16, 3
  add   x17,x17,x15
  mv    \RETREG, x17
  # return x17

   

2:
  #restore regs
  ld	x9, 0(x2)
  ld	x10, 8(x2)
  ld	x11, 16(x2)
  ld	x12, 24(x2)
  ld	x13, 32(x2)
  ld	x14, 40(x2)
  ld	x15, 48(x2)
  ld	x16, 56(x2)
  ld	x17, 64(x2)
  ld	x18, 72(x2)
  ld	x19, 80(x2)
  addi	x2, x2, 88
  # fence 
  fence
.endm


#//---------------60. Get 2M page(leaf/non-leaf) addr---------------//
.macro MMU_PTW_ADDR_2M VPN, RETREG
  #backup regs 
  #//RETREG should avoid x9~x19
  addi	x2, x2, -88
  sd	x9, 0(x2)
  sd	x10, 8(x2)
  sd	x11, 16(x2)
  sd	x12, 24(x2)
  sd	x13, 32(x2)
  sd	x14, 40(x2)
  sd	x15, 48(x2)
  sd	x16, 56(x2)
  sd	x17, 64(x2)
  sd	x18, 72(x2)
  sd	x19, 80(x2)
  

  csrr x9, satp
  li x10,0x1000000000000000
  and x9,x9,x10
  bnez x9, 1f   #jump to SV48 PTW 2M 

   
  # get PPN from satp in x9
  csrr  x9, satp
  li    x10, 0xfffffffffff
  and   x9, x9, x10
  
  # get VPN2 in x10
  li    x10, \VPN
  li    x11, 0x7fc0000
  and   x10,x10,x11
  srli  x10, x10, 18    
   
  # cfig first-level page
  # level-1 page, entry addr:{ppn,VPN2,3'b0} in x15
  slli  x14, x9, 12
  slli  x11, x10, 3
  add   x15, x14, x11

  # write pte into level-1 page
  # level-2 base addr in x12
  addi  x12, x10, 1
  add   x12, x12, x9
  slli  x14, x12, 10
  li    x13, 0xc1
  or    x13, x13, x14
  ####sd    x13, 0(x15)
  # x13 = {satp.ppn+vpn2+1, 2'b0, 8'hc1}
  
  
  # cfig level-2 page
  # get VPN1 in x16
  li    x11, \VPN
  li    x13, 0x3fe00
  and   x16, x11, x13
  srli  x16, x16, 9  

  # level-2 page, entry addr:{pte.ppn,VPN1,3'b0} in x17
  slli  x13, x12, 12
  slli  x17, x16, 3
  add   x17, x17, x13
  mv    \RETREG, x17
  # return x17
  j 2f #to restore gpr
 

  #SV48 PTW 2M BEG
1:
  csrr  x9, satp
  li    x10, 0xfffffffffff
  and   x9, x9, x10
  
  # get VPN3 in x10
  li    x10, \VPN
  li    x11, 0xff8000000
  and   x10,x10,x11
  srli  x10, x10, 27    
   
  # cfig first-level page
  # level-1 page, entry addr:{ppn,VPN3,3'b0} in x15
  slli  x14, x9, 12
  slli  x11, x10, 3
  add   x15, x14, x11

  # write pte into level-1 page
  # level-2 base addr in x12
  addi  x12, x10, 1
  add   x12, x12, x9
  slli  x14, x12, 10
  li    x13, 0xc1
  or    x13, x13, x14
  ####sd    x13, 0(x15)
  
  # cfig level-2 page
  # get VPN2 in x16
  li    x11, \VPN
  li    x13, 0x7fc0000
  and   x16, x11, x13
  srli  x16, x16, 18  

  # level-2 page, entry addr:{pte.ppn,VPN2,3'b0} in x17
  slli  x13, x12, 12
  slli  x17, x16, 3
  add   x17, x17, x13

  # write pte into level-2 page
  # level-3 base addr in x18: PPN+1+2^9+{vpn3,vpn2}
  li    x10, \VPN
  li    x11, 0x7ffffff
  and   x10, x10,x11
  li    x11, 0x200
  addi  x11, x11, 1
  add   x11, x11, x9  
  srli  x10, x10, 18
  add   x18, x11, x10
  slli  x19, x18, 10 
  li    x13, 0xc1
  or    x19, x19, x13
  ####sd    x19, 0(x17)
  
  # cfig level-3 page
  # get VPN1 in x12
  li    x11, \VPN
  li    x12, 0x3fe00
  and   x12, x12, x11
  srli  x12, x12, 9

  # get level-3 page addr x17
  slli  x18, x18, 12
  slli  x12, x12, 3
  add   x17, x18, x12
  mv    \RETREG, x17


  #restore regs
2:
  ld	x9, 0(x2)
  ld	x10, 8(x2)
  ld	x11, 16(x2)
  ld	x12, 24(x2)
  ld	x13, 32(x2)
  ld	x14, 40(x2)
  ld	x15, 48(x2)
  ld	x16, 56(x2)
  ld	x17, 64(x2)
  ld	x18, 72(x2)
  ld	x19, 80(x2)
  addi	x2, x2, 88
  # fence 
  fence
.endm


#//---------------61. Get 1G page(leaf/non-leaf) addr---------------//
.macro MMU_PTW_ADDR_1G VPN, RETREG
  #backup regs 
  #//RETREG should avoid x9~x19
  addi	x2, x2, -88
  sd	x9, 0(x2)
  sd	x10, 8(x2)
  sd	x11, 16(x2)
  sd	x12, 24(x2)
  sd	x13, 32(x2)
  sd	x14, 40(x2)
  sd	x15, 48(x2)
  sd	x16, 56(x2)
  sd	x17, 64(x2)
  sd	x18, 72(x2)
  sd	x19, 80(x2)
  
  #figure out sv 48 or sv39, default SV39
  csrr x9, satp
  li x10,0x1000000000000000
  and x9,x9,x10
  bnez x9, 1f   #jump to SV48 PTW 1G 
 
  # get PPN from satp in x9
  csrr  x9, satp
  li    x10, 0xfffffffffff
  and   x9, x9, x10
  
  # get VPN2 in x10
  li    x10, \VPN
  li    x11, 0x7fc0000
  and   x10,x10,x11
  srli  x10, x10, 18    
   
  # cfig first-level page
  # level-1 page, entry addr:{ppn,VPN2,3'b0} in x15
  slli  x14, x9, 12
  slli  x11, x10, 3
  add   x15, x14, x11
  mv    \RETREG, x15
  # return x15
  j 2f #jump to restore

   
  # get PPN from satp in x9
1:
  csrr  x9, satp
  li    x10, 0xfffffffffff
  and   x9, x9, x10
  
  # get VPN2 in x10
  li    x10, \VPN
  li    x11, 0xff8000000
  and   x10,x10,x11
  srli  x10, x10, 27    
   
  # cfig first-level page
  # level-1 page, entry addr:{ppn,VPN3,3'b0} in x15
  slli  x14, x9, 12
  slli  x11, x10, 3
  add   x15, x14, x11
  # write pte into level-1 page
  # level-2 base addr in x12
  addi  x12, x10, 1
  add   x12, x12, x9
  slli  x14, x12, 10
  li    x13, 0xc1
  or    x13, x13, x14
  ####sd    x13, 0(x15)
  
  # cfig level-2 page
  # get VPN1 in x16
  li    x11, \VPN
  li    x13, 0x7fc0000
  and   x16, x11, x13
  srli  x16, x16, 18
  # level-2 page, entry addr:{pte.ppn,VPN2,3'b0} in x17
  slli  x13, x12, 12
  slli  x17, x16, 3
  add   x17, x17, x13
  mv    \RETREG, x17
  # return x17

  #restore regs
2:
  ld	x9, 0(x2)
  ld	x10, 8(x2)
  ld	x11, 16(x2)
  ld	x12, 24(x2)
  ld	x13, 32(x2)
  ld	x14, 40(x2)
  ld	x15, 48(x2)
  ld	x16, 56(x2)
  ld	x17, 64(x2)
  ld	x18, 72(x2)
  ld	x19, 80(x2)
  addi	x2, x2, 88
  # fence 
  fence
.endm


#//---------------62. Get 512G page(leaf/non-leaf) addr---------------//
.macro MMU_PTW_ADDR_512G VPN, RETREG
  #backup regs 
  #//RETREG should avoid x9~x15
  addi	x2, x2, -56
  sd	x9, 0(x2)
  sd	x10, 8(x2)
  sd	x11, 16(x2)
  sd	x12, 24(x2)
  sd	x13, 32(x2)
  sd	x14, 40(x2)
  sd	x15, 48(x2)
  
  # get PPN from satp in x9
  csrr  x9, satp
  li    x10, 0xfffffffffff
  and   x9, x9, x10
  
  # get VPN3 in x10
  li    x10, \VPN
  li    x11, 0xff8000000
  and   x10,x10,x11
  srli  x10, x10, 27    
   
  # cfig first-level page
  # level-1 page, entry addr:{ppn,VPN3,3'b0} in x15
  slli  x14, x9, 12
  slli  x11, x10, 3
  add   x15, x14, x11
  mv    \RETREG, x15
  # return x15

  #restore regs
  ld	x9, 0(x2)
  ld	x10, 8(x2)
  ld	x11, 16(x2)
  ld	x12, 24(x2)
  ld	x13, 32(x2)
  ld	x14, 40(x2)
  ld	x15, 48(x2)
  addi	x2, x2, 56
  # fence 
  fence
.endm


#//---------------63. Make 4K NAPOT single pte---------------//
#//VPN should be 4'h0 align, PPN should be 4'h8 align
.macro MMU_PTW_4K_NAPOT VPN, PPN, FLAG, SVPBMT
  #backup regs 
  addi	x2, x2, -88
  sd	x9, 0(x2)
  sd	x10, 8(x2)
  sd	x11, 16(x2)
  sd	x12, 24(x2)
  sd	x13, 32(x2)
  sd	x14, 40(x2)
  sd	x15, 48(x2)
  sd	x16, 56(x2)
  sd	x17, 64(x2)
  sd	x18, 72(x2)
  sd	x19, 80(x2)

  csrr x9, satp
  li x10,0x1000000000000000
  and x9,x9,x10
  bnez x9, 1f  #jump to SV48 PTW 4K 
 
  # get PPN from satp in x9
  csrr  x9, satp
  li    x10, 0xfffffffffff
  and   x9, x9, x10
  
  # get VPN2 in x10
  li    x10, \VPN
  li    x11, 0x7fc0000
  and   x10,x10,x11
  srli  x10, x10, 18    
   
  # cfig first-level page
  # level-1 page, entry addr:{ppn,VPN2,3'b0} in x15
  slli  x14, x9, 12
  slli  x11, x10, 3
  add   x15, x14, x11
  # write pte into level-1 page
  # level-2 base addr in x12
  addi  x12, x10, 1
  add   x12, x12, x9
  slli  x14, x12, 10
  li    x13, 0xc1
  or    x13, x13, x14
  sd    x13, 0(x15)
  
  # cfig level-2 page
  # get VPN1 in x16
  li    x11, \VPN
  li    x13, 0x3fe00
  and   x16, x11, x13
  srli  x16, x16, 9  
  # level-2 page, entry addr:{pte.ppn,VPN1,3'b0} in x17
  slli  x13, x12, 12
  slli  x17, x16, 3
  add   x17, x17, x13
  # write pte into level-2 page
  # level-3 base addr in x18: PPN+1+2^9+{vpn2,vpn1}
  li    x11, 0x7ffffff
  li    x10, \VPN
  and   x10, x11,x10
  li    x11, 0x200
  addi  x11, x11, 1
  add   x11, x11, x9  
  srli  x10, x10, 9
  add   x18, x11, x10
  slli  x19, x18, 10 
  li    x13, 0xc1
  or    x19, x19, x13
  sd    x19, 0(x17)
  
  # cfig level-3 page
  # get VPN0 in x12
  li    x11, \VPN
  li    x12, 0x1ff
  and   x12, x12, x11
  # get level-3 page addr x17
  slli  x18, x18, 12
  slli  x12, x12, 3
  add   x17, x18, x12
  # write pte into level-3 page
  li    x11, \PPN
  slli  x11, x11, 10

  li    x12, \SVPBMT
  slli  x12, x12, 61
  or    x11, x11, x12

  # NAPOT
  li    x12, 0x1
  slli  x12, x12, 63
  or    x11, x11, x12

  li    x13, \FLAG
  or    x11, x11, x13
  sd    x11, 0(x17)
  j 2f 

 
 
1:
  #SV48 MMU PTW 4K BEG
  csrr  x9, satp
  li    x10, 0xfffffffffff
  and   x9, x9, x10

  # get VPN3 in x10
  li    x10, \VPN
  li    x11, 0xff8000000
  and   x10,x10,x11
  srli  x10, x10, 27    
   
  # cfig first-level page
  # level-1 page, entry addr:{ppn,VPN3,3'b0} in x15
  slli  x14, x9, 12
  slli  x11, x10, 3
  add   x15, x14, x11   #first page entry address
  # write pte into level-1 page
  # level-1 base addr in x12
  addi  x12, x10, 1
  add   x12, x12, x9    # level2 ppn 
  slli  x14, x12, 10
  li    x13, 0xc1
  or    x13, x13, x14
  sd    x13, 0(x15)
  
  # cfig level-2 page
  # get VPN2 in x16
  li    x11, \VPN
  li    x13, 0x7fc0000
  and   x16, x11, x13
  srli  x16, x16, 18  
  # level-2 page, entry addr:{pte.ppn,VPN2,3'b0} in x17
  slli  x13, x12, 12
  slli  x17, x16, 3
  add   x17, x17, x13            #second page entry address
  # write pte into level-2 page
  # level-3 base addr in x18: PPN+1+2^9+{vpn3,vpn2}

  li    x10, \VPN
  li    x11, 0xfffffffff
  and   x10, x10,x11
  li    x11, 0x200
  addi  x11, x11, 1
  add   x11, x11, x9  
  srli  x10, x10, 18
  add   x18, x11, x10    #level 3 ppn
  slli  x19, x18, 10 
  li    x13, 0xc1
  or    x19, x19, x13
  sd    x19, 0(x17)
  

  # cfig level-3 page
  # get VPN1 in x16
  li    x11, \VPN
  li    x13, 0x3fe00
  and   x16, x11, x13
  srli  x16, x16, 9  
  # level-3 page, entry addr:{pte.ppn,VPN1,3'b0} in x17
  slli  x13, x18, 12
  slli  x17, x16, 3
  add   x17, x17, x13  #third page entry address

  # write pte into level-3 page
  # level-4 base addr in x18: PPN+1+2^9 + 2^9 *2^9 +{vpn3,vpn2,vpn1}
  li    x11, 0x200
  li    x12, 0x40000
  add   x11,x12,x11
  addi  x11, x11,0x1
  add   x11, x11,x9
  li    x12, \VPN
  li    x13, 0xfffffffff
  and   x12, x13,x12
  srli  x12, x12, 9
  add   x12, x12, x11  #level 4 ppn
  slli  x16, x12,10
  li    x13, 0xc1
  or    x13, x16,x13
  sd    x13, 0(x17)
  

  # get level-4 page addr x17
  li    x11, \VPN
  li    x13, 0x1ff
  and   x16, x11, x13
  slli  x15, x12, 12
  slli  x17, x16, 3
  add   x17,x17,x15

#write ppn and flag  
  li    x11, \PPN
  slli  x11, x11, 10

  li    x12, \SVPBMT
  slli  x12, x12, 61
  or    x11, x11, x12

  # NAPOT
  li    x12, 0x1
  slli  x12, x12, 63
  or    x11, x11, x12

  li    x13, \FLAG
  or    x11, x11, x13
  sd    x11, 0(x17)
   

2:
  #restore regs
  ld	x9, 0(x2)
  ld	x10, 8(x2)
  ld	x11, 16(x2)
  ld	x12, 24(x2)
  ld	x13, 32(x2)
  ld	x14, 40(x2)
  ld	x15, 48(x2)
  ld	x16, 56(x2)
  ld	x17, 64(x2)
  ld	x18, 72(x2)
  ld	x19, 80(x2)
  addi	x2, x2, 88
  # fence 
  fence
.endm


#//---------------64. Make 4K NAPOT single pte using reg---------------//
# VPN is reg (x8), PPN should be 4'h8 align
.macro MMU_PTW_4K_NAPOT_REG VPN, PPN, FLAG, SVPBMT
  #backup regs 
  addi	x2, x2, -88
  sd	x9, 0(x2)
  sd	x10, 8(x2)
  sd	x11, 16(x2)
  sd	x12, 24(x2)
  sd	x13, 32(x2)
  sd	x14, 40(x2)
  sd	x15, 48(x2)
  sd	x16, 56(x2)
  sd	x17, 64(x2)
  sd	x18, 72(x2)
  sd	x19, 80(x2)

  csrr x9, satp
  li x10,0x1000000000000000
  and x9,x9,x10
  bnez x9, 1f  #jump to SV48 PTW 4K 
 
  # get PPN from satp in x9
  csrr  x9, satp
  li    x10, 0xfffffffffff
  and   x9, x9, x10
  
  # get VPN2 in x10
  mv    x10, \VPN
  li    x11, 0x7fc0000
  and   x10,x10,x11
  srli  x10, x10, 18    
   
  # cfig first-level page
  # level-1 page, entry addr:{ppn,VPN2,3'b0} in x15
  slli  x14, x9, 12
  slli  x11, x10, 3
  add   x15, x14, x11
  # write pte into level-1 page
  # level-2 base addr in x12
  addi  x12, x10, 1
  add   x12, x12, x9
  slli  x14, x12, 10
  li    x13, 0xc1
  or    x13, x13, x14
  sd    x13, 0(x15)
  
  # cfig level-2 page
  # get VPN1 in x16
  mv    x11, \VPN
  li    x13, 0x3fe00
  and   x16, x11, x13
  srli  x16, x16, 9  
  # level-2 page, entry addr:{pte.ppn,VPN1,3'b0} in x17
  slli  x13, x12, 12
  slli  x17, x16, 3
  add   x17, x17, x13
  # write pte into level-2 page
  # level-3 base addr in x18: PPN+1+2^9+{vpn2,vpn1}
  li    x11, 0x7ffffff
  mv    x10, \VPN
  and   x10, x11,x10
  li    x11, 0x200
  addi  x11, x11, 1
  add   x11, x11, x9  
  srli  x10, x10, 9
  add   x18, x11, x10
  slli  x19, x18, 10 
  li    x13, 0xc1
  or    x19, x19, x13
  sd    x19, 0(x17)
  
  # cfig level-3 page
  # get VPN0 in x12
  mv    x11, \VPN
  li    x12, 0x1ff
  and   x12, x12, x11
  # get level-3 page addr x17
  slli  x18, x18, 12
  slli  x12, x12, 3
  add   x17, x18, x12
  # write pte into level-3 page
  li    x11, \PPN
  slli  x11, x11, 10

  li    x12, \SVPBMT
  andi  x12, x12, 0x3
  slli  x12, x12, 61
  or    x11, x11, x12

  # NAPOT
  li    x12, 0x1
  slli  x12, x12, 63
  or    x11, x11, x12

  li    x13, \FLAG
  or    x11, x11, x13
  sd    x11, 0(x17)
  j 2f 

 
 
1:
  #SV48 MMU PTW 4K BEG
  csrr  x9, satp
  li    x10, 0xfffffffffff
  and   x9, x9, x10

  # get VPN3 in x10
  mv    x10, \VPN
  li    x11, 0xff8000000
  and   x10,x10,x11
  srli  x10, x10, 27    
   
  # cfig first-level page
  # level-1 page, entry addr:{ppn,VPN3,3'b0} in x15
  slli  x14, x9, 12
  slli  x11, x10, 3
  add   x15, x14, x11   #first page entry address
  # write pte into level-1 page
  # level-1 base addr in x12
  addi  x12, x10, 1
  add   x12, x12, x9    # level2 ppn 
  slli  x14, x12, 10
  li    x13, 0xc1
  or    x13, x13, x14
  sd    x13, 0(x15)
  
  # cfig level-2 page
  # get VPN2 in x16
  mv    x11, \VPN
  li    x13, 0x7fc0000
  and   x16, x11, x13
  srli  x16, x16, 18  
  # level-2 page, entry addr:{pte.ppn,VPN2,3'b0} in x17
  slli  x13, x12, 12
  slli  x17, x16, 3
  add   x17, x17, x13            #second page entry address
  # write pte into level-2 page
  # level-3 base addr in x18: PPN+1+2^9+{vpn3,vpn2}

  mv    x10, \VPN
  li    x11, 0xfffffffff
  and   x10, x10,x11
  li    x11, 0x200
  addi  x11, x11, 1
  add   x11, x11, x9  
  srli  x10, x10, 18
  add   x18, x11, x10    #level 3 ppn
  slli  x19, x18, 10 
  li    x13, 0xc1
  or    x19, x19, x13
  sd    x19, 0(x17)
  

  # cfig level-3 page
  # get VPN1 in x16
  mv    x11, \VPN
  li    x13, 0x3fe00
  and   x16, x11, x13
  srli  x16, x16, 9  
  # level-3 page, entry addr:{pte.ppn,VPN1,3'b0} in x17
  slli  x13, x18, 12
  slli  x17, x16, 3
  add   x17, x17, x13  #third page entry address

  # write pte into level-3 page
  # level-4 base addr in x18: PPN+1+2^9 + 2^9 *2^9 +{vpn3,vpn2,vpn1}
  li    x11, 0x200
  li    x12, 0x40000
  add   x11,x12,x11
  addi  x11, x11,0x1
  add   x11, x11,x9
  mv    x12, \VPN
  li    x13, 0xfffffffff
  and   x12, x13,x12
  srli  x12, x12, 9
  add   x12, x12, x11  #level 4 ppn
  slli  x16, x12,10
  li    x13, 0xc1
  or    x13, x16,x13
  sd    x13, 0(x17)
  

  # get level-4 page addr x17
  mv    x11, \VPN
  li    x13, 0x1ff
  and   x16, x11, x13
  slli  x15, x12, 12
  slli  x17, x16, 3
  add   x17,x17,x15

#write ppn and flag  
  li    x11, \PPN
  slli  x11, x11, 10

  li    x12, \SVPBMT
  andi  x12, x12, 0x3
  slli  x12, x12, 61
  or    x11, x11, x12

  # NAPOT
  li    x12, 0x1
  slli  x12, x12, 63
  or    x11, x11, x12

  li    x13, \FLAG
  or    x11, x11, x13
  sd    x11, 0(x17)
   

2:
  #restore regs
  ld	x9, 0(x2)
  ld	x10, 8(x2)
  ld	x11, 16(x2)
  ld	x12, 24(x2)
  ld	x13, 32(x2)
  ld	x14, 40(x2)
  ld	x15, 48(x2)
  ld	x16, 56(x2)
  ld	x17, 64(x2)
  ld	x18, 72(x2)
  ld	x19, 80(x2)
  addi	x2, x2, 88
  # fence 
  fence
.endm


#//---------------65. Make 4K NAPOT all 16 ptes---------------//
# VPN should be 4'h0 align, PPN should be 4'h8 align
.macro MMU_PTW_4K_NAPOT_ALL VPN, PPN, FLAG, SVPBMT
  #backup regs 
  addi	x2, x2, -8
  sd	x8, 0(x2)
  
  # x8 for VPN, repeat 16 entries
  li    x8, \VPN
  MMU_PTW_4K_NAPOT_REG x8, \PPN, \FLAG, \SVPBMT
  addi  x8, x8, 1
  MMU_PTW_4K_NAPOT_REG x8, \PPN, \FLAG, \SVPBMT
  addi  x8, x8, 1
  MMU_PTW_4K_NAPOT_REG x8, \PPN, \FLAG, \SVPBMT
  addi  x8, x8, 1
  MMU_PTW_4K_NAPOT_REG x8, \PPN, \FLAG, \SVPBMT
  addi  x8, x8, 1
  MMU_PTW_4K_NAPOT_REG x8, \PPN, \FLAG, \SVPBMT
  addi  x8, x8, 1
  MMU_PTW_4K_NAPOT_REG x8, \PPN, \FLAG, \SVPBMT
  addi  x8, x8, 1
  MMU_PTW_4K_NAPOT_REG x8, \PPN, \FLAG, \SVPBMT
  addi  x8, x8, 1
  MMU_PTW_4K_NAPOT_REG x8, \PPN, \FLAG, \SVPBMT

  addi  x8, x8, 1
  MMU_PTW_4K_NAPOT_REG x8, \PPN, \FLAG, \SVPBMT
  addi  x8, x8, 1
  MMU_PTW_4K_NAPOT_REG x8, \PPN, \FLAG, \SVPBMT
  addi  x8, x8, 1
  MMU_PTW_4K_NAPOT_REG x8, \PPN, \FLAG, \SVPBMT
  addi  x8, x8, 1
  MMU_PTW_4K_NAPOT_REG x8, \PPN, \FLAG, \SVPBMT
  addi  x8, x8, 1
  MMU_PTW_4K_NAPOT_REG x8, \PPN, \FLAG, \SVPBMT
  addi  x8, x8, 1
  MMU_PTW_4K_NAPOT_REG x8, \PPN, \FLAG, \SVPBMT
  addi  x8, x8, 1
  MMU_PTW_4K_NAPOT_REG x8, \PPN, \FLAG, \SVPBMT
  addi  x8, x8, 1
  MMU_PTW_4K_NAPOT_REG x8, \PPN, \FLAG, \SVPBMT


  #restore regs
  ld	x8, 0(x2)
  addi	x2, x2, 88
.endm


