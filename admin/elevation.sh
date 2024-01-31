echo "This will create zip files for logger connectors or arcmc. after zipfile please indicate connector - logger - arcmc"
#echo "Creating files structure for"

DIRPATH=$(dirname $(readlink -f $1))

#echo "el path es ${DIRPATH}"


touch elevation.txt
touch description.txt
touch analisys.txt
mkdir evidence
