#! /bin/bash 
#a
# check arguments
if [ "$#" -lt 1 ] ; then
    echo "Usage: $0 filename_to_trash" 
    exit 1
fi

# if file doesn't exist - quit
if [ ! -e $1 ] ; then
    echo "requested file $1 not found" 
    exit 1
fi

#b
# create .trash
if [ ! -d "$HOME/.trash" ]; then
    mkdir $HOME/.trash
fi

#c
# create link
lnkname=` date +"%y%m%d-%H%M%S"`
ln "$1" $HOME/.trash/$lnkname 2>/dev/null
if [ $? -ne 0 ]; then
    echo "can not create link"
    exit 1
fi

# remove file from argument
rm "$1" 2>/dev/null
if [ $? -ne 0 ]; then
    echo "faild to remove file $1"
    exit 1
fi

#d
#write log
echo "$PWD $1 $lnkname" >> $HOME/.trash.log

