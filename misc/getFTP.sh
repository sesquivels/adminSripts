
HOST=ftp-pro.houston.softwaregrp.com
USER=$1
PWD=$2

ftp -p -n -i $HOST <<END_SCRIPT
quote USER $USER
quote PASS $PWD
mget * -a 
quit
END_SCRIPT
exit 0
