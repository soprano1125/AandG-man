#!/bin/bash


if [ "$REC_DATE" == "" ]; then
	REC_DATE=`date +"%Y%m%d%H%M"`
fi
FILENAME=$output"_"$REC_DATE

USER_AGENT="`$COMMON_PATH/getParam common mozilla_agent` (`$COMMON_PATH/getParam common user_agent`) A&G/0.1"
HTTP_TIMEOUT=`$COMMON_PATH/getParam common http_timeout`

TTY=`tty`
if [ "$TTY" == "not a tty" ]; then
	DISP_MODE="/dev/null"
else
	DISP_MODE=$TTY
fi

