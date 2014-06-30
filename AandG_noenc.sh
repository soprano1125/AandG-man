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
OUT_FILE=$OUT_DIR/$FILENAME.flv
FILE_OWNER=`$COMMON_PATH/getParam common owner`

mkdir -p $OUT_DIR $TEMP_PATH $PROG_PATH/log/
$PROG_PATH/AandG_download.sh $time $TEMP_PATH/$FILENAME.flv
if [ $? -ne 0 ]; then
	exit 1;
fi

sudo mv $TEMP_PATH/$FILENAME.flv $OUT_FILE
sudo chown -R $FILE_OWNER $OUT_DIR

exit 0

