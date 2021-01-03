#!/bin/bash
if [ "$1" == "" ]; then
  echo "Usage: $0 /path/to/sconsdir"
  exit 2
fi
SCONSDIR=$1
cd repo/
#git checkout -q 6ee27c0db68515e3faa71bf25c0ed7a883ecf697
git checkout -q 0f7ef250b2a1ba4592e9c53528d7ddde89447133

git clean -q -fdx
rm .sconsign.dblite
python ${SCONSDIR}/scons.py --tree=prune # --debug=explain # --tree=prune --debug=stacktrace
python ${SCONSDIR}/sconsign.py -c .sconsign.dblite | sort -k2
echo "--md5--"
md5 * | sort -k 4


echo "=============== part 2 ====================="
git checkout -q  master
python ${SCONSDIR}/scons.py --tree=prune # --debug=explain  # --debug=stacktrace
python ${SCONSDIR}/sconsign.py -c .sconsign.dblite | sort -k2
echo "--md5--"
md5 * | sort -k 4

# echo "=============== part 3 ====================="

# git checkout -q 6ee27c0db68515e3faa71bf25c0ed7a883ecf697
# python ${SCONSDIR}/scons.py # --debug=explain # --tree=prune --debug=stacktrace
# python ${SCONSDIR}/sconsign.py -c .sconsign.dblite | sort -k2
# echo "--md5--"
# md5 * | sort -k 4

# echo "=============== part 4 ====================="
# git checkout -q  master
# python ${SCONSDIR}/scons.py # --debug=explain  #--tree=prune --debug=stacktrace
# python ${SCONSDIR}/sconsign.py -c .sconsign.dblite | sort -k2
# echo "--md5--"
# md5 * | sort -k 4
