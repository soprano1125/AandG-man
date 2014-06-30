#/bin/sh


if [ $# -eq 1 ]; then
	time=$1
	output=""

elif [ $# -eq 2 ]; then
	time=$1
	output=$2

else
	echo "usage : $0 rec_time [outputfile]"
	exit 1
fi

HOME_PATH=/home/ubuntu/AandG-man
PROG_PATH=$HOME_PATH
TEMP_PATH=$HOME_PATH/share/temp
COMMON_PATH=$PROG_PATH/common

. $COMMON_PATH/base.sh
cd $PROG_PATH

OUT_DIR=$HOME_PATH/share/AandG
FILE_OWNER=`$COMMON_PATH/getParam common owner`

mkdir -p $OUT_DIR $TEMP_PATH $PROG_PATH/log/
$PROG_PATH/AandG_download.sh $time $TEMP_PATH/$FILENAME.flv
if [ $? -ne 0 ]; then
	exit 1;
fi

echo "## encode ###########################################################"
ret=0
for file in `ls -1 $TEMP_PATH/$FILENAME*`;do
	#
	# ffmpeg 
	# 
	FFMPEG_LOG="$PROG_PATH/log/$FILENAME.log"
	echo $OUT_FILE >> $FFMPEG_LOG

	OUT_FILE=`echo $file | sed -e "s|$TEMP_PATH|$OUT_DIR|g"`
	OUT_FILE=`echo $OUT_FILE | sed -e "s|.flv|.mp3|g"`
	sudo ffmpeg -y -i $file -ab 128k -ar 44100 -ac 2 $OUT_FILE 2>> $FFMPEG_LOG
	FFMPEG_STATUS=$?

	#
	# remove
	#
	if [ $FFMPEG_STATUS -ne 0 ]
	then
		# エンコードミスした時の保険
		MESSAGE="$FILENAME.mp3:$channel convert miss"
	else
		rm -rf $file
		MESSAGE="$FILENAME.mp3:$channel convert done"
	fi

#	$HOME_PATH/twitter/post.sh "$MESSAGE" > /dev/null
	echo "$MESSAGE" 1>&2
	ret=$((ret + FFMPEG_STATUS))
done
sudo chown -R $FILE_OWNER $OUT_DIR
exit $ret;
