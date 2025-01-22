;[]-----------------------------------------------------------------[]
;|      SETJMP.ASM -- entry points for Windows versions of setjmp()  |
;|                    and longjmp()                                  |
;|                                                                   |
;|      C/C++ Run Time Library        Version 4.0                    |
;|                                                                   |
;|      Copyright (c) 1987, 1991 by Borland International Inc.       |
;|      All Rights Reserved.                                         |
;[]-----------------------------------------------------------------[]

        INCLUDE RULES.ASI

        assume cs:_TEXT

public  SETJMP
public  LONGJMP

extrn   CATCH : far
extrn   THROW : far

_TEXT   segment

SETJMP  proc DIST
        jmp CATCH       ; the catch buffer used by Windows is smaller
                        ; than the one used by TC, so we can simply
                        ; call the Windows function with our buffer
SETJMP  endp

LONGJMP proc DIST
        jmp THROW
LONGJMP endp

ends

end
