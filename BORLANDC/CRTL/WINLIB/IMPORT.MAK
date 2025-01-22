# IMPORT.MAK - build the WINDOWS import library.

LIBDIR = ..\lib
LIBFILE = $(LIBDIR)\import.lib

$(LIBFILE) : gdi.def kernel.def keyboard.def sound.def user.def win87em.def
	if exist $(LIBFILE) del $(LIBFILE)
	implib $(LIBFILE) gdi.def kernel.def keyboard.def sound.def user.def win87em.def
