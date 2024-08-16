################################################################################################
# This file includes some macros which will be used to process vector.                         #
#                                 Included Macro                                               #
#  1.  INIT_VREG_IMM        SET VREG = {H64, L64}                                              #
#  2.  INIT_VREG_REG        SET VREG = {REGH, REGL}                                            #
#  3.  VREG_IMM             SET VREG = {HIMM64, LIMM64}                                        #
#  4.  VREG_CMP             Check if VREG1 == VREG2                                            #
#  5.  INIT_VREG            Initialize VREG                                                    #
#  6.  INIT_FREG            Initialize FREG                                                    #
################################################################################################



#//---------------1. SET VREG = {H64, L64}---------------/
.macro INIT_VREG_IMM VREG, H64, L64
#backup regs 
addi x2, x2, -24
sd x15, 0x0(x2)
sd x16, 0x8(x2)
sd x17, 0x10(x2)

#backup vtype vl vstart
csrr	x15,vtype
csrr	x16,vl
csrr	x17,vstart

addi	x2, x2, -24
sd	x15,0x0(x2)
sd	x16,0x8(x2)
sd	x17,0x10(x2)

#modify vtype vl to lmul 1 sew 64b vl 1 
#reset vstart to 0
#li	x16,0x1
vsetvli	x16,x0,e32,m1

#updt high 64 bit 
li x16, 0x20
li		x15, \L64
vslide1down.vx	\VREG,\VREG,x15
srl x15,x15,x16
vslide1down.vx	\VREG,\VREG,x15
#updt low 64 bit 
li		x15, \H64
vslide1down.vx	\VREG,\VREG,x15
srl x15,x15,x16
vslide1down.vx	\VREG,\VREG,x15

#restore vtype vl vstart
#vtype
ld	x15,0x0(x2)
#vl
ld	x16,0x8(x2)
#start
ld	x17,0x10(x2)
addi	x2, x2, 24

vsetvl	x0,x16,x15
csrw	vstart,x17

#restore regs
ld x15, 0x0(x2)
ld x16, 0x8(x2)
ld x17, 0x10(x2)
addi x2, x2, 24
.endm


#//---------------2. SET VREG = {REGH, REGL}---------------/
.macro INIT_VREG_REG VREG, REGH, REGL
#backup regs 
addi x2, x2, -24
sd x15, 0x0(x2)
sd x16, 0x8(x2)
sd x17, 0x10(x2)

#backup vtype vl vstart
csrr	x15,vtype
csrr	x16,vl
csrr	x17,vstart

addi	x2, x2, -24
sd	x15,0x0(x2)
sd	x16,0x8(x2)
sd	x17,0x10(x2)

#modify vtype vl to lmul 1 sew 64b vl 1 
#reset vstart to 0
#li	x16,0x1
vsetvli	x16,x0,e64,m1

#recover initial reg val
ld	x15,24(x2)
ld	x16,32(x2)
ld	x17,40(x2)

#updt high 64 bit 
vslide1down.vx	\VREG,\VREG,\REGL
#updt low 64 bit 
vslide1down.vx	\VREG,\VREG,\REGH

#restore vtype vl vstart
#vtype
ld	x15,0x0(x2)
#vl
ld	x16,0x8(x2)
#start
ld	x17,0x10(x2)
addi	x2, x2, 24

vsetvl	x0,x16,x15
csrw	vstart,x17

#restore regs
ld x15, 0x0(x2)
ld x16, 0x8(x2)
ld x17, 0x10(x2)
addi x2, x2, 24
.endm


#//---------------3. SET VREG = {HIMM64, LIMM64}---------------/
.macro VREG_IMM VREG, HIMM64, LIMM64
#sew =32
#updt high 64 bit
vsetvli x15,x0,e64
li		x15, \LIMM64
vslide1down.vx	\VREG,\VREG,x15
#updt low 64 bit 
li		x15, \HIMM64
vslide1down.vx	\VREG,\VREG,x15
vsetvli x15,x0,e32
.endm


#//---------------4. Check if VREG1 == VREG2---------------/
.macro VREG_CMP VREG1, VREG2
# set i-th LSB in v4 = VERG1[i] != VREG2[i] for i = vstart : vl
vmsne.vv v4, \VREG1, \VREG2
# count the number of value 1 and write to x5
vmpopc.m  x5, v4
bnez x5, TEST_FAIL
.endm


#//---------------5. Initialize VREG---------------/
.macro INIT_VREG
  li		x31, 0x1
  vsetvli	x31, x0, e8, m1
  vmv.v.x	v0, x0 
  vmv.v.x	v1, x0 
  vmv.v.x	v2, x0 
  vmv.v.x	v3, x0 
  vmv.v.x	v4, x0 
  vmv.v.x	v5, x0 
  vmv.v.x	v6, x0 
  vmv.v.x	v7, x0 
  vmv.v.x	v8, x0 
  vmv.v.x	v9, x0 
  vmv.v.x	v10, x0 
  vmv.v.x	v11, x0 
  vmv.v.x	v12, x0 
  vmv.v.x	v13, x0 
  vmv.v.x	v14, x0 
  vmv.v.x	v15, x0 
  vmv.v.x	v16, x0 
  vmv.v.x	v17, x0 
  vmv.v.x	v18, x0 
  vmv.v.x	v19, x0 
  vmv.v.x	v20, x0 
  vmv.v.x	v21, x0 
  vmv.v.x	v22, x0 
  vmv.v.x	v23, x0 
  vmv.v.x	v24, x0 
  vmv.v.x	v25, x0 
  vmv.v.x	v26, x0 
  vmv.v.x	v27, x0 
  vmv.v.x	v28, x0 
  vmv.v.x	v29, x0 
  vmv.v.x	v30, x0 
  vmv.v.x	v31, x0
##reset x31
  li		x31, 0x0 
.endm

#//---------------6. Initialize FREG---------------/
.macro INIT_FREG
  fmv.d.x f0,x0
  fmv.d.x f1,x0
  fmv.d.x f2,x0
  fmv.d.x f3,x0
  fmv.d.x f4,x0
  fmv.d.x f5,x0
  fmv.d.x f6,x0
  fmv.d.x f7,x0
  fmv.d.x f8,x0
  fmv.d.x f9,x0
  fmv.d.x f10,x0
  fmv.d.x f11,x0
  fmv.d.x f12,x0
  fmv.d.x f13,x0
  fmv.d.x f14,x0
  fmv.d.x f15,x0
  fmv.d.x f16,x0
  fmv.d.x f17,x0
  fmv.d.x f18,x0
  fmv.d.x f19,x0
  fmv.d.x f20,x0
  fmv.d.x f21,x0
  fmv.d.x f22,x0
  fmv.d.x f23,x0
  fmv.d.x f24,x0
  fmv.d.x f25,x0
  fmv.d.x f26,x0
  fmv.d.x f27,x0
  fmv.d.x f28,x0
  fmv.d.x f29,x0
  fmv.d.x f30,x0
  fmv.d.x f31,x0
.endm







