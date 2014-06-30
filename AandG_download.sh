#/bin/sh


if [ $# -eq 2 ]; then
	time=$1
	DUMP_FILE=$2

else
	echo "usage : $0 rec_time outputfile"
	exit 1
fi

HOME_PATH=/home/ubuntu/AandG
PROG_PATH=$HOME_PATH
TEMP_PATH=$HOME_PATH/share/temp
COMMON_PATH=$PROG_PATH/common

. $COMMON_PATH/base.sh
cd $PROG_PATH

#PROG_MODE=`$COMMON_PATH/getParam common prog_mode`
MODULE_PATH=$PROG_PATH/$PROG_MODE

FILE_NAME=`echo $DUMP_FILE | sed -e "s|$TEMP_PATH\/||g"`

isLive=`echo FILE_NAME | perl -ne 'print $1 if(/^(\w+)-(\d+)/i)'`
if [ "$time" = "live" ]; then
	DISP_MODE="/dev/null"
	DUMP_FILE="-"
	time_param=""
	isLive="live"
else
	now_date=`date "+%s"`
	end_date=$((now_date + time))
	DUMP_FILE="$TEMP_PATH/$FILE_NAME-$now_date"
	time_param="-B $time"
	isLive="rec"
fi

SERVER_PARAMS=(`common/getStreamParam | tr '\n' ' '`)
for SERVER_PARAM in ${SERVER_PARAMS[@]}; do
	IFS=','
	set -- $SERVER_PARAM
	SERVER=$1
	APPLICATION=$2
	PLAYPATH=$3
	
	##########################################################
	# rtmpdump
	##########################################################
	MESSAGE="$FILE_NAME: $isLive do"
	echo $MESSAGE 1>&2
	#$HOME_PATH/twitter/post.sh "$MESSAGE" > /dev/null
	rtmpdump -v -r "$SERVER" --playpath "$PLAYPATH" --app "$APPLICATION" $time_param --timeout 1 --live --flv $DUMP_FILE 2> $DISP_MODE
#echo	rtmpdump -v -r "$SERVER" --playpath "$PLAYPATH" --app "$APPLICATION" $time_param --timeout 1 --live --flv $DUMP_FILE 2> $DISP_MODE
#echo 	sleep $time
#	sleep $time
	RTMPDUMP_STATUS=$?

	if [ "$isLive" = "live" ];
	then
		RTMPDUMP_STATUS=$((RTMPDUMP_STATUS - 1))
	else
		now_date=`date "+%s"`
		time=$((end_date - now_date))
		time_param="-B $time"
		if [ ! -s $DUMP_FILE ]; then
			rm -rf $DUMP_FILE; 
		fi
		DUMP_FILE="$TEMP_PATH/$FILE_NAME-$now_date"
	fi

	if [ $RTMPDUMP_STATUS -ne 0 ];
	then
		MESSAGE="$FILE_NAME: $isLive miss"
	else
		MESSAGE="$FILE_NAME: $isLive done"
	fi

	#$HOME_PATH/twitter/post.sh "$MESSAGE" > /dev/null
	echo $MESSAGE 1>&2
	if [ $RTMPDUMP_STATUS -eq 0 ];
	then
		exit $RTMPDUMP_STATUS
	fi
done

