#!/bin/bash
# 	create-message.sh  3.135.277  2018-09-21_18:50:16_CDT  https://github.com/BradleyA/pi-display  uadmin  six-rpi3b.cptx86.com 3.134  
# 	   crap what a bug, LOCAL-HOST link on six was overwritting four and five on the second and thrid run #26 
# 	create-message.sh  3.134.276  2018-09-21_17:00:16_CDT  https://github.com/BradleyA/pi-display  uadmin  six-rpi3b.cptx86.com 3.133  
# 	   formating or DEBUG and ERROR lines 
# 	create-message.sh  3.133.275  2018-09-21_12:34:03_CDT  https://github.com/BradleyA/pi-display  uadmin  six-rpi3b.cptx86.com 3.132  
# 	   add DEBUG to help with #26 
# 	create-message.sh  3.132.274  2018-09-21_11:33:36_CDT  https://github.com/BradleyA/pi-display  uadmin  six-rpi3b.cptx86.com 3.131  
# 	   begin changing echo statements for INFO ERROR DEBUG WARNING to include DATE_STAMP 
# 	create-message.sh  3.99.229  2018-09-10_14:03:38_CDT  https://github.com/BradleyA/pi-display  uadmin  six-rpi3b.cptx86.com 3.98  
# 	   typo 
### 
DEBUG=1                 # 0 = debug off, 1 = debug on
#       set -x
#       set -v
BOLD=$(tput bold)
NORMAL=$(tput sgr0)
###
display_help() {
echo -e "\n${NORMAL}${0} - Store Docker and system information"
echo -e "\nUSAGE\n   ${0} [<CLUSTER>] [<ADMUSER>] [<DATA_DIR>]"
echo    "   ${0} [--help | -help | help | -h | h | -? | ?]"
echo    "   ${0} [--version | -version | -v]"
echo -e "\nDESCRIPTION\nThis script stores Docker information about containers and images in a file"
echo    "on each system in a cluster.  These files are copied to a host and totaled"
echo    "in a file, /usr/local/data/<cluster-name>/MESSAGE.  The MESSAGE file includes"
echo    "the total number of containers, running containers, paused containers,"
echo    "stopped containers, and number of images.  The MESSAGE file is used by a"
echo    "Raspberry Pi Scroll-pHAT and Scroll-pHAT-HD to display the information."
echo -e "\nThis script reads /usr/local/data/<cluster-name>/SYSTEMS file for hosts."
echo    "The hosts are one FQDN or IP address per line for all hosts in a cluster."
echo    "Lines in SYSTEMS file that begin with a # are comments.  The SYSTEMS file"
echo    "is used by Linux-admin/cluster-command.sh, pi-display/create-message.sh,"
echo    "user-work-files/bin/find-code.sh and other scripts.  A different path and"
echo    "cluster command host file can be entered on the command line as the"
echo    "second argument."
echo -e "\nSystem inforamtion about each host is stored in"
echo    "/usr/local/data/<cluster-name>/<host>.  The system information includes cpu"
echo    "temperature in Celsius and Fahrenheit, the system load, memory usage, and disk"
echo    "usage.  The system information will be used by blinkt to display system"
echo    "information about each system in near real time."
echo -e "\nTo avoid many login prompts for each host in a cluster, enter the following:"
echo    "${BOLD}ssh-copy-id uadmin@<host-name>${NORMAL} to each host in the SYSTEMS file."
echo -e "\nOPTIONS"
echo    "   CLUSTER   name of cluster directory, dafault us-tx-cluster-1"
echo    "   ADMUSER   site SRE administrator, default is user running script"
echo    "   DATA_DIR  path to cluster data directory, dafault /usr/local/data/"
echo -e "\nDOCUMENTATION\n   https://github.com/BradleyA/pi-display-board"
echo -e "\nEXAMPLES"
echo -e "   Store message information for a cluster-2\n\n   ${0} cluster-2\n"
if ! [ "${LANG}" == "en_US.UTF-8" ] ; then
        get_date_stamp ; echo -e "${NORMAL}${0} ${LINENO} ${BOLD}[WARNING]${NORMAL}  ${DATE_STAMP}  Your language, ${LANG}, is not supported.\n\tWould you like to help?\n" 1>&2
#       elif [ "${LANG}" == "fr_CA.UTF-8" ] ; then
#               get_date_stamp ; echo -e "${NORMAL}${0} ${LINENO} ${BOLD}[WARNING]${NORMAL}  ${DATE_STAMP}  Display help in ${LANG}" 1>&2
#       else
#               get_date_stamp ; echo -e "${NORMAL}${0} ${LINENO} ${BOLD}[WARNING]${NORMAL}  ${DATE_STAMP}  Your language, ${LANG}, is not supported.\n\tWould you like to help?\n" 1>&2
fi
}

#	Date and time function
get_date_stamp() {
DATE_STAMP=`date +%Y-%m-%d-%H-%M-%S-%Z`
}

#	Default help and version arguments
if [ "$1" == "--help" ] || [ "$1" == "-help" ] || [ "$1" == "help" ] || [ "$1" == "-h" ] || [ "$1" == "h" ] || [ "$1" == "-?" ] || [ "$1" == "?" ] ; then
        display_help
        exit 0
fi
if [ "$1" == "--version" ] || [ "$1" == "-version" ] || [ "$1" == "version" ] || [ "$1" == "-v" ] ; then
        head -2 ${0} | awk {'print$2"\t"$3'}
        exit 0
fi

### 
CLUSTER=${1:-us-tx-cluster-1}
ADMUSER=${2:-${USER}}
DATA_DIR=${3:-/usr/local/data/}
CONTAINERS=0
RUNNING=0
PAUSED=0
STOPPED=0
IMAGES=0
LOCALHOST=`hostname -f`

#	This assumes the admin user has Docker environment variables in ~/.profile.
#	This was added so this script will run in crontab
# >>>	Need to look a the crontab log when testing using craontab
TEMP=`env | grep -i docker`
if [ "${DEBUG}" == "1" ] ; then get_date_stamp ; echo -e "> ${BOLD}DEBUG${NORMAL} ${LINENO}  ${DATE_STAMP}  Docker environment variables >${TEMP}<" 1>&2 ; fi
source ~/.profile
TEMP=`env | grep -i docker`
if [ "${DEBUG}" == "1" ] ; then get_date_stamp ; echo -e "> ${BOLD}DEBUG${NORMAL} ${LINENO}  ${DATE_STAMP}  Docker environment variables after source command >${TEMP}<" 1>&2 ; fi
#
if [ "${DEBUG}" == "1" ] ; then get_date_stamp ; echo -e "> ${BOLD}DEBUG${NORMAL} ${LINENO}  ${DATE_STAMP}  CLUSTER >${CLUSTER}< ADMUSER >${ADMUSER}< DATA_DIR >${DATA_DIR}< PATH >${PATH}<" 1>&2 ; fi

###
#       Check if cluster directory is on system
if [ ! -d ${DATA_DIR}${CLUSTER} ] ; then
	get_date_stamp ; echo -e "${NORMAL}${0} ${LINENO} ${BOLD}[WARN]${NORMAL}  ${DATE_STAMP}  Creating missing directory: ${DATA_DIR}${CLUSTER}\n" 1>&2
	mkdir -p  ${DATA_DIR}${CLUSTER} || { get_date_stamp ; echo -e "\n${NORMAL}${0} ${LINENO} ${BOLD}[ERROR]${NORMAL}  ${DATE_STAMP}  User ${ADMUSER} does not have permission to create ${DATA_DIR}${CLUSTER} directory" 1>&2 ; exit 1; }
	chmod 775 ${DATA_DIR}${CLUSTER}
fi

#	Create MESSAGE file 1) create file for initial running on host, 2) check for write permission
touch ${DATA_DIR}${CLUSTER}/MESSAGE  || { get_date_stamp ; echo -e "\n${NORMAL}${0} ${LINENO} ${BOLD}[ERROR]${NORMAL}  ${DATE_STAMP}  User ${ADMUSER} does not have permission to create MESSAGE file" 1>&2 ; exit 1; }
touch ${DATA_DIR}${CLUSTER}/MESSAGEHD  || { get_date_stamp ; echo -e "\n${NORMAL}${0} ${LINENO} ${BOLD}[ERROR]${NORMAL}  ${DATE_STAMP}  User ${ADMUSER} does not have permission to create MESSAGEHD file" 1>&2 ; exit 1; }
#       Check if SYSTEMS file is on system
#	one FQDN or IP address per line for all hosts in cluster
if ! [ -e ${DATA_DIR}${CLUSTER}/SYSTEMS ] || ! [ -s ${DATA_DIR}${CLUSTER}/SYSTEMS ] ; then
	get_date_stamp ; echo -e "${NORMAL}${0} ${LINENO} ${BOLD}[WARN]${NORMAL}  ${DATE_STAMP}  SYSTEMS file missing or empty, creating SYSTEMS file with local host.\n" 1>&2
	echo -e "\tEdit ${DATA_DIR}${CLUSTER}/SYSTEMS file and add additional hosts that are in the cluster.\n"
	echo -e "###     List of hosts used by cluster-command.sh & create-message.sh"  > ${DATA_DIR}${CLUSTER}/SYSTEMS
	echo -e "#       One FQDN or IP address per line for all hosts in cluster" > ${DATA_DIR}${CLUSTER}/SYSTEMS
	echo -e "###" > ${DATA_DIR}${CLUSTER}/SYSTEMS
	hostname -f > ${DATA_DIR}${CLUSTER}/SYSTEMS
fi
#	Loop through host in SYSTEMS file
if [ "${DEBUG}" == "1" ] ; then get_date_stamp ; echo -e "${NORMAL}${0} ${LINENO} ${BOLD}[INFO]${NORMAL}  ${DATE_STAMP}  Loop through hosts in SYSTEMS file" 1>&2 ; fi
for NODE in $(cat ${DATA_DIR}${CLUSTER}/SYSTEMS | grep -v "#" ); do
	get_date_stamp ; echo -e "${NORMAL}${0} ${LINENO} ${BOLD}[INFO]${NORMAL}  ${DATE_STAMP}  host >${NODE}<" 1>&2
#	Check if ${NODE} is ${LOCALHOST} don't use ssh and scp
	if [ "${LOCALHOST}" != "${NODE}" ] ; then
#	Check if ${NODE} is available on ssh port 
		if [ "${DEBUG}" == "1" ] ; then get_date_stamp ; echo -e "> ${BOLD}DEBUG${NORMAL} ${LINENO}  ${DATE_STAMP}  ${LOCALHOST} != ${NODE}" 1>&2 ; fi
		if $(ssh ${NODE} 'exit' >/dev/null 2>&1 ) ; then
			if [ "${DEBUG}" == "1" ] ; then get_date_stamp ; echo -e "> ${BOLD}DEBUG${NORMAL} ${LINENO}  ${DATE_STAMP}  Make directory and gather docker info on ${NODE}" 1>&2 ; fi
			TEMP="mkdir -p  ${DATA_DIR}${CLUSTER} ; chmod 775 ${DATA_DIR}${CLUSTER} ; docker system info | head -5 > ${DATA_DIR}${CLUSTER}/${NODE}"
			ssh -q -t -i ~/.ssh/id_rsa ${ADMUSER}@${NODE} ${TEMP}
			if [ "${DEBUG}" == "1" ] ; then get_date_stamp ; echo -e "> ${BOLD}DEBUG${NORMAL} ${LINENO}  ${DATE_STAMP}  CELSIUS, FAHRENHEIT from ${NODE}" 1>&2 ; fi
			TEMP="/usr/bin/vcgencmd measure_temp | sed -e 's/temp=//' | sed -e 's/.C$//'"
			CELSIUS=$(ssh -q -t -i ~/.ssh/id_rsa ${ADMUSER}@${NODE} ${TEMP})
			FAHRENHEIT=$(echo ${CELSIUS} | awk -v v=$CELSIUS '{print  1.8 * v +32}')
			TEMP="echo 'Celsius: '${CELSIUS} >> ${DATA_DIR}${CLUSTER}/${NODE} ; echo 'Fahrenheit: '${FAHRENHEIT} >> ${DATA_DIR}${CLUSTER}/${NODE}"
			ssh -q -t -i ~/.ssh/id_rsa ${ADMUSER}@${NODE} ${TEMP}
			if [ "${DEBUG}" == "1" ] ; then get_date_stamp ; echo -e "> ${BOLD}DEBUG${NORMAL} ${LINENO}  ${DATE_STAMP}  CPU" 1>&2 ; fi
			scp -q    -i ~/.ssh/id_rsa /usr/local/bin/CPU_usage.sh ${ADMUSER}@${NODE}:/usr/local/bin/
			ssh -q -t -i ~/.ssh/id_rsa ${ADMUSER}@${NODE} "/usr/local/bin/CPU_usage.sh >> ${DATA_DIR}${CLUSTER}/${NODE}"
			if [ "${DEBUG}" == "1" ] ; then get_date_stamp ; echo -e "> ${BOLD}DEBUG${NORMAL} ${LINENO}  ${DATE_STAMP}  MEMORY" 1>&2 ; fi
			MEMORY=$(ssh -q -t -i ~/.ssh/id_rsa ${ADMUSER}@${NODE} 'free -m | grep Mem:')
			MEMORY=$(echo ${MEMORY} | awk '{printf "Memory_Usage: %s/%sMB %d\n", $3,$2,$3*100/$2 }')
			MEMORY2=$(ssh -q -t -i ~/.ssh/id_rsa ${ADMUSER}@${NODE} 'vcgencmd get_mem arm')
			MEMORY2=$(echo ${MEMORY2} | sed 's/=/: /' | awk '{printf ".Memory_Usage_%s\n", $1" "$2 }')
			MEMORY3=$(ssh -q -t -i ~/.ssh/id_rsa ${ADMUSER}@${NODE} 'vcgencmd get_mem gpu')
			MEMORY3=$(echo ${MEMORY3} | sed 's/=/: /' | awk '{printf ".Memory_Usage_%s\n", $1" "$2 }')
			if [ "${DEBUG}" == "1" ] ; then get_date_stamp ; echo -e "> ${BOLD}DEBUG${NORMAL} ${LINENO}  ${DATE_STAMP}  DISK" 1>&2 ; fi
			DISK=$(ssh -q -t -i ~/.ssh/id_rsa ${ADMUSER}@${NODE} 'df -h  | grep -m 1 "^/"')
			DISK=$(echo ${DISK} | awk '{printf "Disk_Usage: %d/%dGB %d\n", $3,$2,$5}')
			TEMP="echo ${MEMORY} >> ${DATA_DIR}${CLUSTER}/${NODE} ; echo ${MEMORY2} >> ${DATA_DIR}${CLUSTER}/${NODE} ; echo ${MEMORY3} >> ${DATA_DIR}${CLUSTER}/${NODE} ; echo ${DISK} >> ${DATA_DIR}${CLUSTER}/${NODE}"
			ssh -q -t -i ~/.ssh/id_rsa ${ADMUSER}@${NODE} ${TEMP}
			if [ "${DEBUG}" == "1" ] ; then get_date_stamp ; echo -e "> ${BOLD}DEBUG${NORMAL} ${LINENO}  ${DATE_STAMP}  Copy ${NODE} information to ${LOCALHOST}" 1>&2 ; fi
			scp -q    -i ~/.ssh/id_rsa ${ADMUSER}@${NODE}:${DATA_DIR}${CLUSTER}/${NODE} ${DATA_DIR}${CLUSTER}
			if [ "${DEBUG}" == "1" ] ; then get_date_stamp ; echo -e "> ${BOLD}DEBUG${NORMAL} ${LINENO}  ${DATE_STAMP}  Copy SYSTEMS file from ${LOCALHOST} to ${NODE} " 1>&2 ; fi
			scp -q    -i ~/.ssh/id_rsa ${DATA_DIR}${CLUSTER}/SYSTEMS ${ADMUSER}@${NODE}:${DATA_DIR}${CLUSTER}
		else
			get_date_stamp ; echo -e "${NORMAL}${0} ${LINENO} ${BOLD}[WARN]${NORMAL}  ${DATE_STAMP}  ${NODE} found in ${DATA_DIR}${CLUSTER}/SYSTEMS file is not responding to ${LOCALHOST} on ssh port." 1>&2
			touch ${DATA_DIR}${CLUSTER}/${NODE}
		fi
	else
		get_date_stamp ; echo -e "${NORMAL}${0} ${LINENO} ${BOLD}[INFO]${NORMAL}  ${DATE_STAMP}  ${NODE} - Cluster Server" 1>&2
		if [ "${DEBUG}" == "1" ] ; then get_date_stamp ; echo -e "> ${BOLD}DEBUG${NORMAL} ${LINENO}  ${DATE_STAMP}  Gather docker info on ${NODE}" 1>&2 ; fi
		docker system info | head -5 > ${DATA_DIR}${CLUSTER}/${LOCALHOST}
		if [ "${DEBUG}" == "1" ] ; then get_date_stamp ; echo -e "> ${BOLD}DEBUG${NORMAL} ${LINENO}  ${DATE_STAMP}  CELSIUS, FAHRENHEIT from ${NODE}" 1>&2 ; fi
		CELSIUS=$(/usr/bin/vcgencmd measure_temp | sed -e 's/temp=//' | sed -e 's/.C$//')
		echo 'Celsius: '${CELSIUS} >> ${DATA_DIR}${CLUSTER}/${LOCALHOST}
		FAHRENHEIT=$(echo ${CELSIUS} | awk -v v=$CELSIUS '{print  1.8 * v +32}')
		echo 'Fahrenheit: '${FAHRENHEIT} >> ${DATA_DIR}${CLUSTER}/${LOCALHOST}
		if [ "${DEBUG}" == "1" ] ; then get_date_stamp ; echo -e "> ${BOLD}DEBUG${NORMAL} ${LINENO}  ${DATE_STAMP}  CPU" 1>&2 ; fi
		/usr/local/bin/CPU_usage.sh >> ${DATA_DIR}${CLUSTER}/${LOCALHOST}
		if [ "${DEBUG}" == "1" ] ; then get_date_stamp ; echo -e "> ${BOLD}DEBUG${NORMAL} ${LINENO}  ${DATE_STAMP}  MEMORY" 1>&2 ; fi
		MEMORY=$(free -m | awk 'NR==2{printf "Memory_Usage: %s/%sMB %d\n", $3,$2,$3*100/$2 }')
		echo ${MEMORY} >> ${DATA_DIR}${CLUSTER}/${LOCALHOST}
		MEMORY2=$(vcgencmd get_mem arm | sed 's/=/: /' | awk '{printf ".Memory_Usage_%s\n", $1" "$2 }')
		echo ${MEMORY2} >> ${DATA_DIR}${CLUSTER}/${LOCALHOST}
		MEMORY3=$(vcgencmd get_mem gpu | sed 's/=/: /' | awk '{printf ".Memory_Usage_%s\n", $1" "$2 }')
		echo ${MEMORY3} >> ${DATA_DIR}${CLUSTER}/${LOCALHOST}
		if [ "${DEBUG}" == "1" ] ; then get_date_stamp ; echo -e "> ${BOLD}DEBUG${NORMAL} ${LINENO}  ${DATE_STAMP}  DISK" 1>&2 ; fi
		DISK=$(df -h | awk '$NF=="/"{printf "Disk_Usage: %d/%dGB %d\n", $3,$2,$5}')
		echo ${DISK} >> ${DATA_DIR}${CLUSTER}/${LOCALHOST}
		cd ${DATA_DIR}${CLUSTER}
		rm LOCAL-HOST
	fi
	CONTAINERS=`grep -i CONTAINERS ${DATA_DIR}${CLUSTER}/${NODE} | awk -v v=$CONTAINERS '{print $2 + v}'`
	RUNNING=`grep -i RUNNING ${DATA_DIR}${CLUSTER}/${NODE} | awk -v v=$RUNNING '{print $2 + v}'`
	PAUSED=`grep -i PAUSED ${DATA_DIR}${CLUSTER}/${NODE} | awk -v v=$PAUSED '{print $2 + v}'`
	STOPPED=`grep -i STOPPED ${DATA_DIR}${CLUSTER}/${NODE} | awk -v v=$STOPPED '{print $2 + v}'`
	IMAGES=`grep -i IMAGES ${DATA_DIR}${CLUSTER}/${NODE} | awk -v v=$IMAGES '{print $2 + v}'`
	if [ "${DEBUG}" == "1" ] ; then get_date_stamp ; echo -e "> ${BOLD}DEBUG${NORMAL} ${LINENO}  ${DATE_STAMP}  Add Docker information from $NODE{}" 1>&2 ; fi
done
MESSAGE=" CONTAINERS ${CONTAINERS}  RUNNING ${RUNNING}  PAUSED ${PAUSED}  STOPPED ${STOPPED}  IMAGES ${IMAGES}"
echo ${MESSAGE} > ${DATA_DIR}${CLUSTER}/MESSAGE
cp ${DATA_DIR}${CLUSTER}/MESSAGE ${DATA_DIR}${CLUSTER}/MESSAGEHD
tail -n +6 ${DATA_DIR}${CLUSTER}/${LOCALHOST} >> ${DATA_DIR}${CLUSTER}/MESSAGEHD
#	Loop through hosts in SYSTEMS file and update other host information
if [ "${DEBUG}" == "1" ] ; then get_date_stamp ; echo -e "> ${BOLD}DEBUG${NORMAL} ${LINENO}  ${DATE_STAMP}  Loop through hosts in SYSTEMS file and update other host information" 1>&2 ; fi
for NODE in $(cat ${DATA_DIR}${CLUSTER}/SYSTEMS | grep -v "#" ); do
	get_date_stamp ; echo -e "${NORMAL}${0} ${LINENO} ${BOLD}[INFO]${NORMAL}  ${DATE_STAMP}  Copy file to host ${NODE}" 1>&2
#	Check if ${NODE} is ${LOCALHOST} skip already did before the loop
	if [ "${LOCALHOST}" != "${NODE}" ] ; then
#	Check if ${NODE} is available on ssh port
		if $(ssh ${NODE} 'exit' >/dev/null 2>&1 ) ; then
set -x
			scp -q    -i ~/.ssh/id_rsa ${DATA_DIR}${CLUSTER}/* ${ADMUSER}@${NODE}:${DATA_DIR}${CLUSTER}
			TEMP="cd ${DATA_DIR}${CLUSTER} ; ln -sf ${NODE} LOCAL-HOST"
			ssh -q -t -i ~/.ssh/id_rsa ${ADMUSER}@${NODE} ${TEMP}
set +x
		else
			get_date_stamp ; echo -e "${NORMAL}${0} ${LINENO} ${BOLD}[WARN]${NORMAL}  ${DATE_STAMP}  ${NODE} found in ${DATA_DIR}${CLUSTER}/SYSTEMS file is not responding to ${LOCALHOST} on ssh port." 1>&2
		fi
	fi
done
ln -sf ${LOCALHOST} LOCAL-HOST
get_date_stamp ; echo -e "${NORMAL}${0} ${LINENO} ${BOLD}[INFO]${NORMAL}  ${DATE_STAMP}  Done.\n" 1>&2
###
