;[]-----------------------------------------------------------------[]
;|      F_PCMP.ASM -- long pointer comparison                        |
;|                                                                   |
;|      C/C++ Run Time Library        Version 4.0                    |
;|                                                                   |
;|      Copyright (c) 1987, 1991 by Borland International Inc.       |
;|      All Rights Reserved.                                         |
;[]-----------------------------------------------------------------[]

	INCLUDE	RULES.ASI

; calls to this routine are generated by the compiler to compare
; long pointers.

_TEXT   SEGMENT BYTE PUBLIC 'CODE'
        ASSUME  CS:_TEXT
;
;       PCMP@ - compares two pointers on the stack, sets the condition codes
;
;       ax,dx   left hand pointer
;       bx,cx   right hand pointer

        public  PCMP@
        public  F_PCMP@

PCMP@           PROC    FAR
F_PCMP@:
                push    cx
                mov     ch,al
                mov     cl,4
                shr     ax,cl
                add     dx,ax
                mov     al,ch
                mov     ah,bl
                shr     bx,cl
                pop     cx
                add     cx,bx           ; right hand pointer segment
                mov     bl,ah
                and     ax,0fh
                and     bx,0fh
                cmp     dx,cx           ; compare segments
                jne     PCMPend
                cmp     ax,bx           ; compare offsets
PCMPend:
                ret
PCMP@           ENDP
_TEXT   ENDS
        END
