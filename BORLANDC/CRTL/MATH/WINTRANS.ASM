;[]------------------------------------------------------------[]
;|      WINTRANS.ASM                                            |
;|                                                              |
;|      C/C++ Run Time Library        Version 4.0               |
;|                                                              |
;|      Copyright (c) 1987, 1991 by Borland International Inc.  |
;|      All Rights Reserved.                                    |
;[]------------------------------------------------------------[]

;This module is memory model indepedent

        include RULES.ASI

emul    ; generate emulated '87 code

_TEXT   segment
        assume cs:_TEXT

        include ..\emu\e87trans.asm

_TEXT   ends
        end
