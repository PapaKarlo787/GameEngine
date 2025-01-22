;[]-----------------------------------------------------------------[]
;|      SCANTOD.ASM -- Ascii to double conversion                    |
;|                                                                   |
;|      C/C++ Run Time Library        Version 4.0                  |
;|                                                                   |
;|      Copyright (c) 1987, 1991 by Borland International Inc.   |
;|      All Rights Reserved.                                         |
;[]-----------------------------------------------------------------[]

        INCLUDE RULES.ASI

;       External References

extrn		__cvtfak:word
extrn		__ScanTodVector:word

_TEXT   SEGMENT

		public __scantod
__scantod	proc near
		jmp	[__ScanTodVector]
		endp


		public __scanrslt
__scanrslt	proc near
		jmp     [__ScanTodVector + 2]
		endp

		public __scanpop
__scanpop	proc near
		jmp	[__ScanTodVector + 4]
		endp

_TEXT	ENDS
	END
