/*[]------------------------------------------------------------[]*/
/*|                                                              |*/
/*|     stsync.cpp                                               |*/
/*|                                                              |*/
/*|     Class ios                                                |*/
/*|          void ios::sync_with_stdio()                         |*/
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

#include <stdiostr.h>

static short already_done = 0;
static stdiobuf *stdin_siob;
static stdiobuf *stdout_siob;
static stdiobuf *stderr_siob;

void ios::sync_with_stdio()
{
    if( already_done )
        return;     // we only do this once!
    already_done = 1;

    cin.sync();
    cout.flush();
    clog.flush();

    // recover the streambuf space
    cin.rdbuf()->streambuf::~streambuf();
    cout.rdbuf()->streambuf::~streambuf();
    clog.rdbuf()->streambuf::~streambuf();

    // make stdiobufs for the stdio files
    stdin_siob = new stdiobuf(stdin);
    stdout_siob = new stdiobuf(stdout);
    stderr_siob = new stdiobuf(stderr);

    cin = stdin_siob;
    cout = stdout_siob;
    clog = stderr_siob;
    cerr = stderr_siob;

    cout.setf(ios::unitbuf);
    clog.setf(ios::unitbuf);
}
