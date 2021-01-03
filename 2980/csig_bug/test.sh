#!/bin/bash
if [ "$1" == "" ]; then
  echo "Usage: $0 /path/to/sconsdir"
  exit 2
fi
SCONSDIR=$1
cd repo/
touch *
# git checkout 6ee27c0db68515e3faa71bf25c0ed7a883ecf697
git checkout 9cf212a52645f3087a9c7ee0a170efed27d7cd46
git clean -fdx
python ${SCONSDIR}/scons.py --tree=status
git checkout master
python ${SCONSDIR}/scons.py --tree=status
python ${SCONSDIR}/sconsign.py -c .sconsign.dblite
md5 *

