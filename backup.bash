#! /bin/bash

log=$HOME'/backup-report'
# create temp files
touch $HOME/.bckptmp1
touch $HOME/.bckptmp2
#find backup dir. if exists take last
backupdir=`ls ~/ | grep 'Backup-[0-9]\{4\}-[0-9]\{2\}-[0-9]\{2\}$' | tail -1`
#not found
if [ -z $backupdir ]; then
# create new
    backupdir=$HOME'/Backup-'`date +%Y-%m-%d`
    mkdir $backupdir
    echo 'backup dir created: '$backupdir >> $log
    # copy files
    for i in $(ls $HOME/source/); do
	if [ ! -d "$HOME/source/$i" ] ; then
            cp $HOME/source/$i $backupdir/$i
            echo $i >> $log
	fi
    done

else
  # found, check date
  backupdir=$HOME/$backupdir
  curdate=`date +%Y-%m-%d`
  # date from name to secunds
  sec1=`date -d ${backupdir#*-} +%s`
  # date of current date to secunds
  sec2=`date -d $curdate +%s`
  # diff
  declare -i diff=($sec2-$sec1)
  if [ $diff -gt 604800 ]; then
  # if more than 7 days - create new backup dir
     backupdir=$HOME'/Backup-'`date +%Y-%m-%d`
     mkdir $backupdir
     echo 'backup dir created: '$backupdir >> $log
       for i in $(ls $HOME/source/); do
  	if [ ! -d "$HOME/source/$i" ] ; then
            cp $HOME/source/$i $backupdir/$i
            echo $i >> $log
	fi
       done
  else
 # find backup younger than 7 days
 # set flag
  updated=false

  for i in $(ls $HOME/source/); do
   if [ ! -d "$HOME/source/$i" ] ; then
   # check size new and old files
      if [ -e $backupdir/$i ]; then
 	bsize=$(stat -c%s $backupdir/$i)
	ssize=$(stat -c%s $HOME/source/$i)
	if [ $bsize != $ssize ]; then
          # size not equaivalent, create version
	  mv $backupdir/$i $backupdir/$i.$curdate
          # copy new
          cp $HOME/source/$i $backupdir/$i
          updated=true
          # write to temp log
	  echo $i' '$i.$curdate >> $HOME/.bckptmp2
	fi
	else
          cp $HOME/source/$i $backupdir/$i
          echo $i >> $HOME/.bckptmp1
	  updated=true
	fi
   fi
   done

    if $updated; then
       echo 'backup updated: '$backupdir >> $log
       cat $HOME/.bckptmp1 >> $log
       cat $HOME/.bckptmp2 >> $log
    fi

 fi
fi
# remove temp logs
rm $HOME/.bckptmp1
rm $HOME/.bckptmp2

exit 0
