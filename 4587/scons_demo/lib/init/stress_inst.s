.macro MAX_FAIL
  la   x1, __fail 
  jr   x1
.endm  

.macro MAX_SETSINT EXP_CODE, HANDLER_BEGIN,HANDLER_END
  addi sp, sp, -16
  sd   t0, 0(sp)   #address cann't be changed 
  sd   t1, 8(sp)   #it relates to crt0.s

#  addi t0,x0,\VECTOR_MODE
  la   t1, svector_table + 256  #intterrupt start address
  UPDATE_REG_BY_HARTID_FROM_SP t1
#  la   t2, clic_vector_table
#  .long 0x00028463 #beqz t0,label_1
#  mv   t0, t2
#  .short 0xa011    #j label_2
#  #label_1:
#  mv   t0,t1
#  #label_2:
  addi t0,x0,\EXP_CODE
  slli t0,t0,0x3
  add  t1,t1,t0   

  la   t0, \HANDLER_BEGIN
  sd   t0, 0(t1) 

  ld   t1, 8(sp)
  ld   t0, 0(sp)
  addi sp, sp, 16
  j    \HANDLER_END
 
  nop
  nop
  ld   a4, 0(sp)
  addi sp, sp, 16
.endm

.macro MAX_MMU_PTW_1G VPN, PPN, FLAG, SVPBMT
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
  # write pte into level-1 page
  li    x11, \PPN
  li    x12, \SVPBMT
  li    x13, \FLAG
  slli  x11, x11, 10
  slli  x12, x12, 61
  or    x11, x11, x12
  or    x11, x11, x13
  sd    x11, 0(x15)
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
  sd    x13, 0(x15)
  
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
  # write pte into level-2 page
  li    x11, \PPN
  li    x12, \SVPBMT
  li    x13, \FLAG
  slli  x11, x11, 10
  slli  x12, x12, 61
  or    x11, x11, x12
  or    x11, x11, x13
  sd    x11, 0(x17)

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

.macro MAX_MMU_PTW_4K VPN, PPN, FLAG, SVPBMT
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
  li    x12, \SVPBMT
  li    x13, \FLAG
  slli  x11, x11, 10
  slli  x12, x12, 61
  or    x11, x11, x12
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
  li    x12, \SVPBMT
  li    x13, \FLAG
  slli  x11, x11, 10
  slli  x12, x12, 61
  or    x11, x11, x12
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

.macro BBLK_SYNC suffix, addr_reg, temp_reg, ld_reg, addr, core_num
    li \addr_reg, \addr
    li \temp_reg, 0x1
    amoadd.d x0, \temp_reg, (\addr_reg)
WAIT_CPU_\suffix:
    ld \ld_reg, 0(\addr_reg)
    li \temp_reg, \core_num
    bne \ld_reg, \temp_reg, WAIT_CPU_\suffix
.endm

.macro BBLK_PRELOAD suffix, pfdata_addr, pfdata_cnt, pfaddr_reg, fpdata_addr, fpdata_cnt, fpaddr_reg chain_reg, ldmiss_addr, sync_addr0, sync_addr1, core_num
.ifdef DIDT_LDMISS
PRELOAD_LDMISS_DATA_\suffix:
     li x25, LOOP_ITERATIONS
     li x26, \ldmiss_addr

     .ifdef VPU_LOOP
     li x31, 0xc0
     .endif
     .ifdef FPU_LOOP
     li x31, 0x40
     .endif
 
     li x30, 0x0
INIT_LDMISS_DATA_\suffix:
     la x27, FPDATA
     add x27, x27, x31
     ldd x5, x6, (x27)
     sdd x5, x6, (x26)
     ldd x5, x6, 0x10(x27)
     sdd x5, x6, 0x10(x26)
     ldd x5, x6, 0x20(x27)
     sdd x5, x6, 0x20(x26)
     ldd x5, x6, 0x30(x27)
     sdd x5, x6, 0x30(x26)
     addi x26, x26, 0x40
     addi x30, x30, 0x1
     bne x30, x25, INIT_LDMISS_DATA_\suffix
 
     sync.is
.endif

PRELOAD_PFDATA_\suffix:
     la x27, PFDATA
     li x25, \pfdata_cnt
     li x26, \pfdata_addr
 
     li x30, 0x0
INIT_PFDATA_\suffix:
     ldd x5, x6, (x27)
     sdd x5, x6, (x26)
     ldd x5, x6, 0x10(x27)
     sdd x5, x6, 0x10(x26)
     ldd x5, x6, 0x20(x27)
     sdd x5, x6, 0x20(x26)
     ldd x5, x6, 0x30(x27)
     sdd x5, x6, 0x30(x26)
     addi x27, x27, 0x40
     addi x26, x26, 0x40
     ldd x5, x6, (x27)
     sdd x5, x6, (x26)
     ldd x5, x6, 0x10(x27)
     sdd x5, x6, 0x10(x26)
     ldd x5, x6, 0x20(x27)
     sdd x5, x6, 0x20(x26)
     ldd x5, x6, 0x30(x27)
     sdd x5, x6, 0x30(x26)
     addi x27, x27, 0x40
     addi x26, x26, 0x40
     addi x30, x30, 0x1
     bne x30, x25, INIT_PFDATA_\suffix
 
     sync.is
 
PRELOAD_FPDATA_\suffix:
     la x27, FPDATA
     li x25, \fpdata_cnt
     li x26, \fpdata_addr
 
     li x30, 0x0
INIT_FPDATA_\suffix:
     ldd x5, x6, (x27)
     sdd x5, x6, (x26)
     ldd x5, x6, 0x10(x27)
     sdd x5, x6, 0x10(x26)
     ldd x5, x6, 0x20(x27)
     sdd x5, x6, 0x20(x26)
     ldd x5, x6, 0x30(x27)
     sdd x5, x6, 0x30(x26)
     addi x27, x27, 0x40
     addi x26, x26, 0x40
     addi x30, x30, 0x1
     bne x30, x25, INIT_FPDATA_\suffix
 
     .ifdef DIDT_CHAIN
INIT_LOAD_CHAIN_\suffix:
     sd x26, (x26)
     .endif
 
     sync.is
     dcache.ciall
 
     BBLK_SYNC \suffix,x10,x11,x12,\sync_addr0,\core_num
 
#repeat to ensure L2 has clean data
RELOAD_PFDATA_\suffix:
     li x25, \pfdata_cnt
     li x26, \pfdata_addr
 
     li x30, 0x0
REINIT_PFDATA_\suffix:
     ld x5, (x26)
     ld x6, 0x40(x26)
     addi x26, x26, 0x80
     addi x30, x30, 0x1
     bne x30, x25, REINIT_PFDATA_\suffix
 
     sync.is
 
RELOAD_FPDATA_\suffix:
     li x25, \fpdata_cnt
     li x26, \fpdata_addr
 
     li x30, 0x0
REINIT_FPDATA_\suffix:
     ld x5, (x26)
     addi x26, x26, 0x40
     addi x30, x30, 0x1
     bne x30, x25, REINIT_FPDATA_\suffix
 
     .ifdef DIDT_CHAIN
REINIT_LOAD_CHAIN_\suffix:
     ld x26, (x26)
     .endif
 
     sync.is
 
     #update stored regs
     .ifdef DIDT_CHAIN
     add \chain_reg, x0, x26
     .endif
     li \pfaddr_reg, \pfdata_addr
     li \fpaddr_reg, \fpdata_addr
     .ifdef DIDT_LDMISS
     li \chain_reg, \ldmiss_addr
     .endif
 
     BBLK_SYNC RELOAD_SYNC_\suffix,x10,x11,x12,\sync_addr1,\core_num
.endm

.macro BBLK_VCHK vd, vs2, vs1, x1, x2
    vmv.s.x \vd, x0
    vmfeq.vv \vd, \vs2, \vs1
    vmv.x.s \x1, \vd
    add \x2, \x2, \x1
.endm

.macro BBLK_FCHK rd, fs2, fs1,rs1
    feq.d \rd, \fs2, \fs1
    add \rs1, \rs1, \rd
.endm

## basic float inst block
## note could have fs3, reuse as fd here
.macro FPU_BLK fd1, fs1, fs2, fd2, fs3, fs4, fpu_pat
    .if \fpu_pat==1
    fmadd.d \fd1, \fs1, \fs2, \fd1
    fmadd.d \fd2, \fs3, \fs4, \fd2
    .endif
    .if \fpu_pat==2
    fmadd.d \fd1, \fs1, \fs2, \fd1
    fnmadd.d \fd2, \fs3, \fs4, \fd2
    .endif
    .if \fpu_pat==3
    fnmadd.d \fd1, \fs1, \fs2, \fd1
    fnmadd.d \fd2, \fs3, \fs4, \fd2
    .endif
.endm

## basic vector inst block
.macro VFPU_BLK vd1, vs1, vs2, vd2, vs3, vs4, vfpu_pat
    .if \vfpu_pat==1
    vfmacc.vv \vd1, \vs1, \vs2
    vfmacc.vv \vd2, \vs3, \vs4
    .endif
    .if \vfpu_pat==2
    vfmacc.vv \vd1, \vs1, \vs2
    vfnmacc.vv \vd2, \vs3, \vs4
    .endif
    .if \vfpu_pat==3
    vfnmacc.vv \vd1, \vs1, \vs2
    vfnmacc.vv \vd2, \vs3, \vs4
    .endif
.endm

## basic int inst block
.macro INT_BLK rd, rs1, rs2, int_pat
    .if \int_pat==1
    mula \rd, \rs1, \rs2
    .endif
    .if \int_pat==2
    muls \rd, \rs1, \rs2
    .endif
    .if \int_pat==3
    div \rd, \rs1, \rs2
    .endif
.endm

## basic didt loop insert block
.macro DIDT_BLK didt_timer, didt_pat, wfi_en
    .if DIDT_MODE==1
      .if DIDT_NOP==1
      .rept DIDT_NOP_LEN
      nop
      .endr
      .endif

      .if \wfi_en==1
      .if DIDT_WFI==1
      nop
      nop
      wfi
      .endif
      .endif

      .ifdef DIDT_CHAIN
      .rept DIDT_CHAIN_COUNT
      ld \didt_timer, 0x0(\didt_timer)
      .endr
      .endif

      .ifdef DIDT_LDMISS
      .endif

    .endif
.endm

## basic high power block with float ld/st
.macro BBLK_F fd1, fs1, fs2, fd2, fs3, fs4, fpu_pat, rd, rs1, rs2, int_pat, fd3, fd4, rs3, imm, pf_base, pf_offset, inst_pat, didt_timer, didt_pat, wfi_en
    .if \didt_pat!=2
    .if \inst_pat==0
    INT_BLK \rd, \rs1, \rs2, \int_pat
    .endif
    .if \inst_pat==1
    fld \fd3, (\rs3)
    .endif
    .if \inst_pat==2
    fsd \fd3, (\rs3)
    .endif
    .if \inst_pat==3
    ldd \fd3,\fd4, \imm(\rs3)
    .endif
    .if \inst_pat==4
    sdd \fd3,\fd4, \imm(\rs3)
    .endif
	.if \inst_pat==5
	prefetch.w \pf_offset(\pf_base)
	.endif

    FPU_BLK \fd1, \fs1, \fs2, \fd2, \fs3, \fs4, \fpu_pat
    .endif

    .if \didt_pat!=0
    DIDT_BLK \didt_timer, \didt_pat, \wfi_en
    .endif

.endm

## basic high power block with vector ld/st
.macro BBLK_V vd1, vs1, vs2, vd2, vs3, vs4, vfpu_pat, rd, rs1, rs2, int_pat, vd3, rs3, pf_base, pf_offset, inst_pat, didt_timer, didt_pat, wfi_en
    .if \didt_pat!=2
    .if \inst_pat==0
    INT_BLK \rd, \rs1, \rs2, \int_pat
    .endif
    .if \inst_pat==1
    vle64.v \vd3, (\rs3)
    .endif
    .if \inst_pat==2
    vse64.v \vd3, (\rs3)
    .endif
	.if \inst_pat==3
	prefetch.w \pf_offset(\pf_base)
	.endif

    VFPU_BLK \vd1, \vs1, \vs2, \vd2, \vs3, \vs4, \vfpu_pat
    .endif

    .if \didt_pat!=0
    DIDT_BLK \didt_timer, \didt_pat, \wfi_en
    .endif

.endm

##basic high power block with int ld/st
##.macro BBLK_I vd1, vs1, vs2, vd2, vs3, vs4, vfpu_pat, rd, rs1, rs2, int_pat, rd1, rd2, rs3, imm, pf_base, pf_offset, inst_pat 
##    .if \inst_pat==0
##    INT_BLK \rd, \rs1, \rs2, \int_pat
##    .endif
##    .if \inst_pat==1
##    ldd \rd1, \rd2, \imm(\rs3)
##    .endif
##    .if \inst_pat==2
##    sdd \rd1, \rd2, \imm(\rs3)
##    .endif
##	.if \inst_pat==3
##	prefetch.w \pf_offset(\pf_base)
##	.endif
##
##    VFPU_BLK \vd1, \vs1, \vs2, \vd2, \vs3, \vs4, \vfpu_pat
##.endm


.macro BBLK_I vd1, vs1, vs2, vd2, vs3, vs4, vfpu_pat, rd, rs1, rs2, int_pat, rd1, rd2, rs3, pf_base, pf_offset, inst_pat, didt_timer, didt_pat, wfi_en
    .if \didt_pat!=2
    .if \inst_pat==0
    INT_BLK \rd, \rs1, \rs2, \int_pat
    .endif
    .if \inst_pat==1
    ldd \rd1, \rd2, 0(\rs3)
    .endif
    .if \inst_pat==2
    sdd \rd1, \rd2, 0(\rs3)
    .endif
	.if \inst_pat==3
	prefetch.w \pf_offset(\pf_base)
	.endif

    VFPU_BLK \vd1, \vs1, \vs2, \vd2, \vs3, \vs4, \vfpu_pat
    .endif

    .if \didt_pat!=0
    DIDT_BLK \didt_timer, \didt_pat, \wfi_en
    .endif

.endm

