;[]-----------------------------------------------------------------[]
;|      FPINIT.ASM -- Pre/post code for WIN87EM                      |
;|                                                                   |
;|      C/C++ Run Time Library        Version 4.0                    |
;|                                                                   |
;|      Copyright (c) 1987, 1991 by Borland International Inc.       |
;|      All Rights Reserved.                                         |
;[]-----------------------------------------------------------------[]

;This module is memory model indepedent

                include RULES.ASI

                extrn __FPMATH:far
                extrn LOADLIBRARY:far
                extrn __fperr:far
                extrn __turboFloat
                extrn __turboCvt
                extrn __FPVector:dword

                public  FIDRQQ          ; wait, esc
                public  FIARQQ          ; wait, DS:
                public  FICRQQ          ; wait, CS:
                public  FIERQQ          ; wait, ES:
                public  FISRQQ          ; wait, SS:
                public  FIWRQQ          ; nop, wait
                public  FJARQQ          ; Esc nn -> DS:nn
                public  FJCRQQ          ; Esc nn -> CS:nn
                public  FJSRQQ          ; Esc nn -> ES:nn

FIDRQQ          equ     05C32h
FIARQQ          equ     0FE32h
FICRQQ          equ     00E32h
FIERQQ          equ     01632h
FISRQQ          equ     00632h
FIWRQQ          equ     0A23Dh
FJARQQ          equ     04000h
FJCRQQ          equ     0C000h
FJSRQQ          equ     08000h

SIGFPE          equ     8
SIG_DFL         equ     0

                public __windowsFloat
__windowsFloat  equ     0

                public  __cvtfak
__cvtfak        equ     0

_DATA           segment
LibName         db  'WIN87EM', 0
OldSigHandler   dd  0
                ends

_TEXT           segment
                assume cs:_TEXT,ds:DGROUP

__exitfp:       

;                mov     ax, DGROUP
;                push    ds
;                mov     ds, ax

;                mov     ax, word ptr DGROUP:OldSigHandler
;                mov     dx, word ptr DGROUP:OldSigHandler+2
;                mov     bx, 3
;                call    __FPMATH                ;reinstall old signal handler

                mov     bx,2                    ;close WIN87EM
                call    __FPMATH
;                pop     ds
                ret

__initfp:       mov     ax, DGROUP
                push    ds
                mov     ds, ax

                push    ax
                lea     ax, DGROUP:LibName
                push    ax
                call    LOADLIBRARY
                mov     word ptr DGROUP:__FPVector,offset __FPMATH
                mov     word ptr DGROUP:__FPVector+2,seg __FPMATH

                xor     bx,bx                   ;init WIN87EM
                call    __FPMATH

                mov     ax, 353Eh              ; Get Vector 3E (EMU)
                int     21h
                push    bx
                push    es

                mov     ax, offset __fperr
                mov     dx, seg    __fperr
                mov     bx, 3
                call    __FPMATH
                pop     dx
                pop     ax
                mov     word ptr DGROUP:OldSigHandler, ax
                mov     word ptr DGROUP:OldSigHandler+2,dx
                
                pop     ds
                ret
                ends

_INIT_          segment word public 'INITDATA'
                db      0                       ;near call
                db      1                       ;priority 1
                dw      offset __initfp
                dw      ?
                ends

_EXIT_          segment word public 'EXITDATA'
                db      0                       ;near call
                db      1                       ;priority 1
                dw      offset __exitfp
                dw      ?
                ends

                end
