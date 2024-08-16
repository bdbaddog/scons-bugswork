// +FHDR------------------------------------------------------------
//  Imported by Picocom, 2023
// -----------------------------------------------------------------

#include "datatype.h"
#include "uart.h"
#include "stdio.h"

#define APB_BASE                 0x10000000
#define INTC_BASE                0x10010000

//config the interrupt controller
void ck_intc_init()
{
    int *picr = APB_BASE;
        *picr = 0x0;

        // Write NIER
        int *piser = INTC_BASE + 0x10;
        *piser = 0x3f;
}
