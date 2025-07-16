#!/bin/bash

# Clean up.
rm -f .sconsign.dblite
rm -f file[12]

values=('good' 'bad' 'good')

i=0
for val in "${values[@]}"; do
  ((i++))
  echo
  echo "----- Iteration $i: file1 = '$val' -----"

  echo
  echo "$val" > file1
  python ~/devel/scons/git/as_scons/scripts/scons.py --debug=explain --tree=prune

  echo
  echo "File1"
  md5 file1
  cat -n file1

  echo
  echo "File2"
  md5 file2
  cat -n file2

  echo
  echo "DBlite:"
  python ~/devel/scons/git/as_scons/scripts/sconsign.py  .sconsign.dblite
done

exit 
