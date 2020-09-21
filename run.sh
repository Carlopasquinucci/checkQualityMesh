#!/bin/bash


version=1
subversion=0
file=checkMesh-nonortho.log
mkdir check

cp $file check/$file
#open checkMesh and extraplote singnificant data
if [[ $1 == "-help" ]]; then
	echo "Version $version . $subversion"
	echo "-version for version number"
	echo "-help to run the help"
	echo "-checkMesh to run the checkMesh"
	echo "-checkMesh -parallel nprocessor to run the checkMesh in parallel"
	echo "-verbose to maintain all the log file stored"
exit 1
fi


if [[ $1 == "-version" ]]; then
	echo "Version $version . $subversion"
exit 1
fi

if [[ $1 == "-checkMesh" ]]; then
	checkMesh > check/$file
	echo "Mesh checking"
fi

if [[ $2 == "-parallel" ]]; then
	mpirun -np $3 checkMesh > check/$file
	echo "Mesh checking in parallel"
fi

# Number of cells
grep "cells:" check/$file > check/ncells.log
ncells=$(awk '{print $NF}' check/ncells.log)
echo $ncells


# Mesh ok check
if grep "Mesh OK" check/$file; then
  #printf \\n%s\\n "Mesh OK"
  meshOk=0;

exit 0
else  #if the mesh is not ok, it searches if the problem is orthongolality or skweness, or both
  printf \\n%s\\n "Mesh non OK"
  meshOk=1;
	if grep "Non-orthogonality check OK" check/$file; then
	nonOrtho=0;
	else
	nonOrtho=1; #it searches the max ortho
	grep "Mesh non-orthogonality" check/$file> check/ortho.log
	aveortho=$(awk '{print $NF}' check/ortho.log)
	maxortho=$(awk '{print $4}' check/ortho.log)
	echo ave ortho $aveortho
	echo max ortho $maxortho
	echo "Non ortho problematic"
	fi

grep "Max skewness" check/$file > check/skew.log

	if grep "OK" check/skew.log; then
	nskew=0;
	else
	skew=1;
	echo "Skew problematic"
	awk '{print $4}' check/skew.log > check/temp.log
	maxskew=$(sed s/,// check/temp.log)
	echo max skew $maxskew
	fi

fi

if ! [[ $1 == "-verbose" ]] ; then
   rm -r check
fi

