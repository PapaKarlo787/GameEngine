;[]-----------------------------------------------------------------[]
;|      FPERR.ASM -- Entry point for floating point exception        |
;|                                                                   |
;|      C/C++ Run Time Library        Version 4.0                    |
;|                                                                   |
;|      Copyright (c) 1987, 1991 by Borland International Inc.       |
;|      All Rights Reserved.                                         |
;[]-----------------------------------------------------------------[]

;This module is memory model indepedent

                include RULES.ASI

                extrn __FpeHandler:DIST

_TEXT           segment
                assume cs:_TEXT

                public  __fperr
__fperr         proc    far
                push    ds
                push    ax
                mov     ax, DGROUP
                mov     ds, ax
                call    __FpeHandler;
                pop     ax
                pop     ds
                ret
__fperr         endp
                ends

                end

