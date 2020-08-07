

#open checkMesh and extraplote singnificant data


#checkMesh > checkMesh.log

#number of cells --- not robust
#head -n 33 checkMesh.log > head.log
#ncells=$(tail -n 1 head.log | cut -d ":" -f 2)
#

#echo($ncells)

grep "cells:" checkMesh.log > ncells.log
ncells=$(awk '{print $NF}' ncells.log)
echo $ncells



# Mesh ok check
if grep "Mesh OK" checkMesh.log; then
  #printf \\n%s\\n "Mesh OK"
  meshOk=0
else
  printf \\n%s\\n "Mesh non OK"
  meshOk=1
	if grep "Non-orthogonality check OK" checkMesh.log; then
	nonOrtho=0;
	else
	nonOrtho=1;
	#max value
	#ave value
	prinft \\n%s\\n "Non ortho problematic"
	#skew to do
	fi

grep "Max skewness" checkMesh.log > skew.log

	if grep "OK" skew.log; then
	nskew=0;
	else
	skew=1;
	prinft \\n%s\\n "Skew problematic"
	fi

fi
