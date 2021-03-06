#!/bin/bash


item=""
#echo "OPTIND is now $OPTIND"
while getopts ":Dm:e:s:d:" optname
do
    case "$optname" in
    "e")
        # Extract string values
        item=$(/sbin/mdadm --detail ${MD_dev} | grep "${OPTARG}" | awk -F":" '{print $2}')
        echo ${item// /}
            ;;
    "s")
            # echo "Size of the array"
        item=$(/sbin/mdadm --detail ${MD_dev} | grep "${OPTARG}" | awk -F":" '{print $2}')
        echo ${item%%\ \(*}
            ;;
    "d")
            # echo "Devices in the array"
        item=$(/sbin/mdadm --detail ${MD_dev} | tail -n+2 | grep "/dev/" | awk -v x=${OPTARG} '$4 == x {print $5,$6,$7}' )
        echo ${item}
            ;;
    "m")
        # echo "Setting MD RAID"
        MD_dev="${OPTARG}"
        ;;
    "D")
        # echo "Discovery"
        echo -e "{\n\t\"data\":["       
        cat /proc/mdstat | grep ^md | while read line
        do
        MDdev=`echo $line | awk '{print $1}'`
        echo -e "\t{ \"{#MD_DEVICE}\":\t\"/dev/${MDdev}\" },"
        done
        echo -e "\t]\n}"        
        ;;
    "?")
            echo "Unknown option $OPTARG"
            ;;
    ":")
            echo "No argument value for option $OPTARG"
            ;;
    *)
      # Should not occur
            echo "Unknown error while processing options"
            ;;
    esac
#    echo "OPTIND is now $OPTIND"
done

