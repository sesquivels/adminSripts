echo "This will create zip files for logger connectors or arcmc. after zipfile please indicate connector - logger - arcmc"
#echo "Creating files structure for"

DIRPATH=$(dirname $(readlink -f $1))
DIRNAMESCON="connector zips"
DIRNAMESLOG="logger zips"
DIRNAMESARC="arcmc zips"

#echo "el path es ${DIRPATH}"


if [ $2 = "connector" ]
then
        for DIRECTORIES in $DIRNAMESCON
        do
                mkdir  ${DIRPATH}/${DIRECTORIES}
        done
        unzip ${1} -d ${DIRPATH}/connector
        mv ${1} ${DIRPATH}/zips
elif [ $2 = "logger" ]
then
        for DIRECTORIES in $DIRNAMESLOG
        do
                mkdir  ${DIRPATH}/${DIRECTORIES}
        done
        unzip ${1} -d ${DIRPATH}/logger
        mv ${1} ${DIRPATH}/zips
elif [ $2 = "arcmc" ]
then
        for DIRECTORIES in $DIRNAMESARC
        do
                mkdir  ${DIRPATH}/${DIRECTORIES}
        done
        unzip ${1} -d ${DIRPATH}/arcmc
        mv ${1} ${DIRPATH}/zips
fi
