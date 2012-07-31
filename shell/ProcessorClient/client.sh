#!/bin/bash

#
#Simple shell script to send XSAMS documents to processor, wait and download the processing results.
#Accepts two parameters:
#First is XSAMS Processor URL, ending with /service . May need to be quoted.
#Second is URL to XSAMS document, either a VAMDC node output or just saved anywhere. May need to be quoted.
#The downloaded processing result is sent to the standard output.
#This script may be integrated as an input to some scientific tool, if there exists an on-line
#Processor service that converts XSAMS into the format of this tool.
#

#XSAMS Processor URL, ending with /service
PROCESSOR=$1
#URL to XSAMS document, either a VAMDC node output or just saved anywhere 
XSAMSURL=$2

LOCATION=`curl -v --get --data-urlencode "url=${XSAMSURL}" $PROCESSOR 2>&1 \
| grep Location: \
| sed -e 's/<\ Location:\ //g' \
| sed -e 's/[\n\r]//g'`

while curl --head --silent ${LOCATION} | grep -q 202 
do
	echo  "waiting for result from ${LOCATION}" 1>&2
	sleep 1
done

curl --get --silent ${LOCATION}
