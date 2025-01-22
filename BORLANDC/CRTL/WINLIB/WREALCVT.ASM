;[]-----------------------------------------------------------------[]
;|      REALCVT.ASM -- Real number conversion routine                |
;|                                                                   |
;|      C/C++ Run Time Library        Version 4.0                    |
;|                                                                   |
;|      Copyright (c) 1987, 1991 by Borland International Inc.       |
;|      All Rights Reserved.                                         |
;[]-----------------------------------------------------------------[]

        INCLUDE RULES.ASI
        %MACS

;       External References

;ExtSym@ 	_cvtfak, ABS, __CDECL__
extrn		__RealCvtVector:word

_TEXT	SEGMENT

		public __REALCVT
__REALCVT	proc near
		jmp	[__RealCvtVector]
		endp
_TEXT	ENDS
        END
