#!/bin/bash
if [ "$1" == "" ]; then
  echo "Usage: $0 /path/to/sconsdir"
  exit 2
fi
SCONSDIR=$1
cd repo/
git checkout master
git clean -fdx
rm .sconsign.dblite
python ${SCONSDIR}/scons.py --debug=explain --tree=prune
git checkout 6ee27c0db68515e3faa71bf25c0ed7a883ecf697
python ${SCONSDIR}/scons.py --debug=explain --tree=prune
python ${SCONSDIR}/sconsign.py -c .sconsign.dblite
md5 alpha.h
md5 beta.h
md5 gamma.h
md5 main.cpp
md5 main.o
