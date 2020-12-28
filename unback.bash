#! /bin/bash 

# find last dir with backup
backupdir=$HOME/`ls ~/ | grep 'Backup-[0-9]\{4\}-[0-9]\{2\}-[0-9]\{2\}$' | tail -1`
if [ -z $backupdir ]; then
# exit if doesn't exits
    echo 'Backup not found'
    exit 1
else
# create restore
    if [ ! -d "$HOME/restore" ]; then
        mkdir $HOME/restore
    fi
# restore file without date
    cd $backupdir
    ls | grep -v '[0-9]\{4\}-[0-9]\{2\}-[0-9]\{2\}$' | xargs cp -t $HOME/restore/

fi

exit 0
