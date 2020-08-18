
version=1
subversion=0
file=checkMesh-nonortho.log

#open checkMesh and extraplote singnificant data
if [[ $1 == "-help" ]]; then
	echo "Version $version . $subversion"
	echo "-version for version number"
	echo "-help to run the help"
	echo "-checkMesh to run the checkMesh"
	echo "-checkMesh -parallel nprocessor to run the checkMesh in parallel"
exit 1
fi


if [[ $1 == "-version" ]]; then
	echo "Version $version . $subversion"
exit 1
fi

if [[ $1 == "-checkMesh" ]]; then
	checkMesh > checkMesh.log
	echo "Mesh checking"
fi

if [[ $2 == "-parallel" ]]; then
	mpirun -np $3 checkMesh > checkMesh-nonortho.log.log
	echo "Mesh checking in parallel"
fi

# Number of cells
grep "cells:" $file > ncells.log
ncells=$(awk '{print $NF}' ncells.log)
echo $ncells


# Mesh ok check
if grep "Mesh OK" checkMesh-nonortho.log; then
  #printf \\n%s\\n "Mesh OK"
  meshOk=0;

exit 0
else  #if the mesh is not ok, it searches if the problem is orthongolality or skweness, or both
  printf \\n%s\\n "Mesh non OK"
  meshOk=1;
	if grep "Non-orthogonality check OK" $file; then
	nonOrtho=0;
	else
	nonOrtho=1; #it searches the max ortho
	grep "Mesh non-orthogonality" $file> ortho.log
	aveortho=$(awk '{print $NF}' ortho.log)
	maxortho=$(awk '{print $4}' ortho.log)
	echo ave ortho $aveortho
	echo max ortho $maxortho
	echo "Non ortho problematic"
	fi

grep "Max skewness" $file > skew.log

	if grep "OK" skew.log; then
	nskew=0;
	else
	skew=1;
	echo "Skew problematic"
	awk '{print $4}' skew.log > temp.log
	maxskew=$(sed s/,// temp.log)
	echo max skew $maxskew
	fi

fi
