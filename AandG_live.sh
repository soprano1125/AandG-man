#/bin/sh


HOME_PATH=/home/ubuntu/AandG-man
PROG_PATH=$HOME_PATH
COMMON_PATH=$PROG_PATH/common

. $COMMON_PATH/base.sh
cd $PROG_PATH

AUTHOR="JOQR"
STATION_NAME="超A&G+"

#
# rtmpdump
#
$PROG_PATH/AandG_download.sh live live-$REC_DATE | vlc --meta-title " " --meta-author $AUTHOR --meta-artist $STATION_NAME --meta-date $REC_DATE --play-and-exit --no-one-instance --no-sout-display-video - 2> /dev/null 

exit 0

