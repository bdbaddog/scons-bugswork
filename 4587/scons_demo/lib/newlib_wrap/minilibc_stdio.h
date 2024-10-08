// +FHDR------------------------------------------------------------
//  Imported by Picocom, 2023
// -----------------------------------------------------------------

/*
 * minilibc stdio
 *
 * Copyright (C): 2012 Hangzhou C-SKY Microsystem Co.,LTD.
 * Author: Junshan Hu (junshan_hu@c-sky.com)
 * Contrbutior: Chunqiang Li
 * Date: 2012-5-4
 */

#ifndef _MINILIBC_STDIO_H_
#define _MINILIBC_STDIO_H__

#include <stdarg.h>

#define BUFSIZE 2048

struct __stdio_file {
    int fd;
    int flags;
    unsigned int bs;    /* read: bytes in buffer */
    unsigned int bm;    /* position in buffer */
//    unsigned int buflen;    /* length of buf */
//    char *buf;
    struct __stdio_file *next;    /* for fflush */
    unsigned char ungetbuf;
    char ungotten;
    unsigned int lock;
};

#define ERRORINDICATOR 1
#define EOFINDICATOR 2
#define BUFINPUT 4
#define BUFLINEWISE 8
#define NOBUF 16
#define STATICBUF 32
#define FDPIPE 64
#define CANREAD 128
#define CANWRITE 256

#include <stdio.h>

/* ..scanf */
struct arg_scanf {
    void *data;
    int (*getch)(void*);
    int (*putch)(int,void*);
};

int __v_scanf(struct arg_scanf* fn, const char *format, va_list arg_ptr);

struct arg_printf {
    void *data;
    int (*put)(void*,size_t,void*);
};

int __v_printf(struct arg_printf* fn, const char *format, va_list arg_ptr);
int __isinf(double d);
int __isnan(double d);
int __dtostr(double d,char *buf,unsigned int maxlen,unsigned int prec,unsigned int prec2);
int __lltostr(char *s, int size, unsigned long long i, int base, char UpCase);
int __ltostr(char *s, unsigned int size, unsigned long i, unsigned int base, int UpCase);


#endif /*  _MINILIBC_STDIO_H_ */
