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

HOME_PATH=/home/ubuntu/AandG
PROG_PATH=$HOME_PATH
TEMP_PATH=$HOME_PATH/share/temp
COMMON_PATH=$PROG_PATH/common

. $COMMON_PATH/base.sh
cd $PROG_PATH

OUT_DIR=$HOME_PATH/share/AandG
OUT_FILE=$OUT_DIR/$FILENAME.mp3
#FILE_OWNER=`$COMMON_PATH/getParam common owner`

mkdir -p $OUT_DIR $TEMP_PATH $PROG_PATH/log/
$PROG_PATH/AandG_download.sh $time $TEMP_PATH/$FILENAME.flv
if [ $? -ne 0 ]; then
	exit 1;
fi

#
# ffmpeg 
# 
FFMPEG_LOG="$PROG_PATH/log/$channel_$FILENAME.log"
echo $OUT_FILE >> $FFMPEG_LOG
sudo ffmpeg -y -i $TEMP_PATH/$FILENAME.flv -ab 128k -ar 44100 -ac 2 $OUT_FILE 2>> $FFMPEG_LOG
FFMPEG_STATUS=$?

#
# remove
#
if [ $FFMPEG_STATUS -ne 0 ]
then
	# エンコードミスした時の保険
	MESSAGE="$FILENAME.mp3:$channel convert miss"
else
	sudo chown -R $FILE_OWNER $OUT_DIR
	rm -rf $TEMP_PATH/$FILENAME.flv
	MESSAGE="$FILENAME.mp3:$channel convert done"
fi

#$HOME_PATH/twitter/post.sh "$MESSAGE" > /dev/null
echo "$MESSAGE" 1>&2
exit $FFMPEG_STATUS

