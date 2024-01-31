echo "This will create zip files for logger connectors or arcmc. after zipfile please indicate connector - logger - arcmc"
#echo "Creating files structure for"

DIRPATH=$(dirname $(readlink -f $1))
DIRNAMESCON="connector zips"
DIRNAMESLOG="logger zips"
DIRNAMESARC="arcmc zips"
COUNTER=0
#echo "el path es ${DIRPATH}"

mkdir  ${DIRPATH}/zips

for ZIPS in $@
do
	COUNTER=$(( COUNTER + 1 )) 
     mkdir  ${DIRPATH}/${DIRECTORIES} 
     unzip ${ZIPS} -d ${DIRPATH}/dir$COUNTER
     mv ${ZIPS} ${DIRPATH}/zips 
done
