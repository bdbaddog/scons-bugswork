# ****************************************************************************
# *                                                                          *
# * C-Sky Microsystems Confidential                                          *
# * -------------------------------                                          *
# * This file and all its contents are properties of C-Sky Microsystems. The *
# * information contained herein is confidential and proprietary and is not  *
# * to be disclosed outside of C-Sky Microsystems except under a             *
# * Non-Disclosure Agreement (NDA).                                          *
# *                                                                          *
# ****************************************************************************
#FILE NAME      : Makefile
#AUTHOR         : 
#FUNCTION       : the Makefile compile the test patterns  
#	          The flow of compilation:
#	        *.[c|asm]-> *.o->*.elf-> *.hex-> *.pat
#-------------------------------------------------------------------------
#
#-------------------------------------------------------------------
# the compiler toolset setting
#TOOL_EXTENSION	=  /iotproj/rv_tools/riscv64-elf-x86_64_2.0.3/bin/
CC      = ${TOOL_EXTENSION}/riscv64-unknown-elf-gcc
AS      = ${TOOL_EXTENSION}/riscv64-unknown-elf-as
LINK    = ${TOOL_EXTENSION}/riscv64-unknown-elf-ld
OBJDUMP = ${TOOL_EXTENSION}/riscv64-unknown-elf-objdump
OBJCOPY = ${TOOL_EXTENSION}/riscv64-unknown-elf-objcopy
CONVERT	=../tests/bin/Srec2vmem

SSRC = $(wildcard *.S)
sSRC = $(wildcard *.s)
CSRC = $(wildcard *.c)

OBJECTS = $(SSRC:%.S=%.o) $(sSRC:%.s=%.o) $(CSRC:%.c=%.o)

#INCDIR = -I/tools/cskytools/csky-abiv2-elf-tools-x86_64-20130312/csky-abiv2-elf/include -I.

FLAG_ABI = 
# FLAG_MARCH = -mtune=c920 
FLAG_MARCH = -mtune=c920
#CPU_ARCH_FLAG_0 => CPU Arch: c920, c920v
ifeq (${CPU_ARCH_FLAG_0}, c920)
  FLAG_MARCH += -march=rv64imafdcv_zicbom_zicbop_zicboz_zicond1p0_zihintntl0p2_zihintpause_zawrs_zfa0p1_zfbfmin0p8_zfh_zca_zcb_zcd_zba_zbb_zbc_zbs_zvfbfmin0p8_zvfbfwma0p8_svinval_svpbmt_xtheadc_xtheadvdot
  FLAG_ABI   = -mabi=lp64d
else
  FLAG_MARCH += -march=rv64imafdcv_zicbom_zicbop_zicboz_zicond1p0_zihintntl0p2_zihintpause_zawrs_zfa0p1_zfbfmin0p8_zfh_zca_zcb_zcd_zba_zbb_zbc_zbs_zvfbfmin0p8_zvfbfwma0p8_svinval_svpbmt_xtheadc_xtheadvdot
  FLAG_ABI   = -mabi=lp64d
endif
CFLAGS = ${FLAG_MARCH} ${FLAG_ABI} 

ifeq (${CASENAME}, coremark)
  CFLAGS += -c -O3 -static -funroll-all-loops -finline-limit=500 -fgcse-sm -fno-schedule-insns --param max-rtl-if-conversion-unpredictable-cost=100 -msignedness-cmpiv -fno-code-hoisting -mno-thread-jumps1 -mno-iv-adjust-addr-cost -mno-expand-split-imm -DITERATIONS=10000
  # CFLAGS += -c -v -funroll-all-loops -finline-limit=500 -fgcse-sm -fno-schedule-insns --param max-rtl-if-conversion-unpredictable-cost=100 -fno-code-hoisting -mno-thread-jumps1 -mno-iv-adjust-addr-cost -DITERATIONS=10000 -O3 -static -mbit-translate
else
  CFLAGS += -c -O2
endif

CFLAGS += --specs=nano.specs

LINKFLAGS = -Tlinker.lcf -nostartfiles ${FLAG_MARCH} ${FLAG_ABI}

# LINKLIBS  = -L${TOOL_PATH}/lib/gcc/riscv64-unknown-elf/8.1.0/rv32imac
# LINKLIBS += -L${TOOL_PATH}/riscv64-unknown-elf/lib/rv32imac
# LINKLIBS += -L${TOOL_PATH}/riscv32-unknown-elf/lib

LINKLIBS = -lc -lgcc

OBJDUMPFLAGS = -S -Mnumeric

HEXFLAGS	= -O srec

%.o : %.c
	${CC} -c ${CFLAGS} -o $@ $<

%.o : %.s
	${CC} -c ${CFLAGS} -o $@ $<

%.o : %.S
	${CC} -c ${CFLAGS} -o $@ $<

${FILE}.elf : ${OBJECTS} linker.lcf
	${CC} ${LINKFLAGS} ${LINKLIBS} ${OBJECTS} -o $@ -lm 

${FILE}.obj : ${FILE}.elf
	${OBJDUMP} ${OBJDUMPFLAGS} $< > $@

INST_HEX = ${FILE}_inst.hex
DATA_HEX = ${FILE}_data.hex
FILE_HEX = ${FILE}.hex

${FILE}.hex : ${FILE}.elf
	${OBJCOPY} ${HEXFLAGS} $< ${INST_HEX} -j .text*  -j .rodata* -j .eh_frame*
	${OBJCOPY} ${HEXFLAGS} $< ${DATA_HEX} -j .data*  -j .bss -j .COMMON
	${OBJCOPY} ${HEXFLAGS} $< $@ 

INST_PAT = inst.pat
DATA_PAT = data.pat
FILE_PAT = case.pat

%.pat	: %.hex
	rm -f *.pat
	${CONVERT} ${INST_HEX} ${INST_PAT}
	${CONVERT} ${DATA_HEX} ${DATA_PAT}
	${CONVERT} ${FILE_HEX} ${FILE_PAT}


#--------------------------------------------------------------------
# target setting
.PHONY :all
all : ${FILE}.pat ${FILE}.hex ${FILE}.elf ${FILE}.obj

#---------------------------------------------------------------------
# clean some medium code and .pat
.PHONY :clean 
clean:
	rm -rf *.o *.pat *.elf *.obj *.hex

