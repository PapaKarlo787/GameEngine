/*[]------------------------------------------------------------[]*/
/*|                                                              |*/
/*|     ioststd.cpp                                              |*/
/*|                                                              |*/
/*|     Class iostream                                           |*/
/*|          implements standard streams:                        |*/
/*|              cin                                             |*/
/*|              cout                                            |*/
/*|              cerr                                            |*/
/*|              clog                                            |*/
/*|                                                              |*/
/*[]------------------------------------------------------------[]*/

/*[]------------------------------------------------------------[]*/
/*|                                                              |*/
/*|     C/C++ Run Time Library - Version 4.0                     |*/
/*|                                                              |*/
/*|                                                              |*/
/*|     Copyright (c) 1990, 1991 by Borland International        |*/
/*|     All Rights Reserved.                                     |*/
/*|                                                              |*/
/*[]------------------------------------------------------------[]*/

#include <ioconfig.h>
#include <filesys.h>
#include <fstream.h>

// this allows calling a constructor for an existing object
inline void * operator new(size_t, void *p)
{
    return p;
}
istream_withassign cin;
ostream_withassign cout;
ostream_withassign cerr;
ostream_withassign clog;

static filebuf *stdin_filebuf;
static filebuf *stdout_filebuf;
static filebuf *stderr_filebuf;


#pragma warn -use
static void Iostream_init()
{
#pragma startup Iostream_init 16

    stdin_filebuf = new filebuf(F_stdin);
    stdout_filebuf = new filebuf(F_stdout);
    stderr_filebuf = new filebuf(F_stderr);

    // call constructors for standard streams
    new (&cin) istream_withassign;
    new (&cout) ostream_withassign;
    new (&cerr) ostream_withassign;
    new (&clog) ostream_withassign;
    // attach the standard files to the standard streams
    cin = stdin_filebuf;
    cout = stdout_filebuf;
    clog = stderr_filebuf;
    cerr = stderr_filebuf;

    // tie cin, cerr, and clog to cout
    cin.tie(&cout);
    clog.tie(&cout);
    cerr.tie(&cout);

    // unit-buffer cerr
    cerr.setf(ios::unitbuf);

    // if cout is the screen, unit-buffer it too
    if( isatty(1) )
        cout.setf(ios::unitbuf);
}

void Iostream_delete()
{
#pragma exit Iostream_delete 16

    delete stdin_filebuf;
    delete stdout_filebuf;
    delete stderr_filebuf;
}
