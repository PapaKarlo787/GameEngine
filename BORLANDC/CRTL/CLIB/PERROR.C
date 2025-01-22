/*-------------------------------------------------------------------------*
 * filename - perror.c
 *
 * function(s)
 *        perror - system error messages
 *--------------------------------------------------------------------------*/

/*[]------------------------------------------------------------[]*/
/*|                                                              |*/
/*|     C/C++ Run Time Library - Version 4.0                     |*/
/*|                                                              |*/
/*|                                                              |*/
/*|     Copyright (c) 1987, 1991 by Borland International        |*/
/*|     All Rights Reserved.                                     |*/
/*|                                                              |*/
/*[]------------------------------------------------------------[]*/

#include <stdio.h>
#include <stdlib.h>
#include <errno.h>

#undef sys_errlist
#undef sys_nerr

char    *sys_errlist[] = {
    "Error 0",
    "Invalid function number",
    "No such file or directory",
    "Path not found",
    "Too many open files",
    "Permission denied",
    "Bad file number",
    "Memory arena trashed",
    "Not enough memory",
    "Invalid memory block address",
    "Invalid environment",
    "Invalid format",
    "Invalid access code",
    "Invalid data",
    0,
    "No such device",
    "Attempted to remove current directory",
    "Not same device",
    "No more files",
    "Invalid argument",
    "Arg list too big",
    "Exec format error",
    "Cross-device link",
    0,
    0,
    0,
    0,
    0,
    0,
    0,
    0,
    0,
    0,
    "Math argument",
    "Result too large",
    "File already exists"
    "File already exists",
    "Possible deadlock"
};

int     sys_nerr = sizeof(sys_errlist) / sizeof(sys_errlist[0]);

/*---------------------------------------------------------------------*

Name            perror - system error messages

Usage           void perror(const char *string);

Prototype in    stdio.h

Description     perror prints an error message to stderr, describing
                the most recent error encountered in a system call from the
                current program.

                First the argument string is printed, then a colon, then the
                message corresponding to the current value of errno, and finally
                a newline. The convention is to pass the name of the program as
                the argument string.

                To provide more control over message formatting, the array of
                message strings is provided in sys_errlist. errno can be used as
                an index into the array to find the string corresponding to the
                error number. The string does not include any newline character.

                sys_nerr contains the number of entries in the array.

                Refer to errno, sys_errlist, and sys_nerr in the "Variables"
                section of this chapter for more information.

Return value    None

*---------------------------------------------------------------------*/
void _FARFUNC perror(const char _FAR *s)
{
    char    *cp;

    if (errno < sys_nerr && errno >= 0)
        cp = sys_errlist[errno];
    else
        cp = "Unknown error";

    fprintf(stderr, "%s: %s\n", s, cp);
}
