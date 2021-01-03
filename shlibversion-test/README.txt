Problem description
===================

  SharedLibrary messed up dependencies when used with SHLIBVERSION argument.
  The build order may be wrong when linking programs that use shared libraries
  generated with SharedLibrary(..., SHLIBVERSION=...). Especially in parallel
  builds.

How to run
==========

  scons -j2

Result
======

  ptomulik@barakus:$ scons -j2
  scons: Reading SConscript files ...
  scons: done reading SConscript files.
  scons: Building targets ...
  g++ -o foo.os -c -fPIC -I. foo.cpp
  g++ -o main.o -c -I. main.cpp
  g++ -o libfoo.so.0.1.2 -shared -Wl,-Bsymbolic -Wl,-soname=libfoo.so.0 foo.os -L.
  g++ -o main main.o -L. -lfoo
  /usr/bin/ld: cannot find -lfoo
  collect2: error: ld returned 1 exit status
  scons: *** [main] Error 1
  scons: building terminated because of errors.

My scons version (scons --version)
==================================

  SCons by Steven Knight et al.:
          script: v2.3.6.rel_2.3.5:3347:d31d5a4e74b6[MODIFIED], 2015/07/31 14:36:10, by bdbaddog on hpmicrodog
          engine: v2.3.6.rel_2.3.5:3347:d31d5a4e74b6[MODIFIED], 2015/07/31 14:36:10, by bdbaddog on hpmicrodog
          engine path: ['/usr/lib/scons/SCons']
  Copyright (c) 2001 - 2015 The SCons Foundation
