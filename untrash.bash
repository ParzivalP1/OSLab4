#! /bin/bash 

# check arguments
if [ "$#" -lt 1 ] ; then
    echo "Usage: $0 filename_to_restore" 
    exit 1
fi

# read pwd, name and delete date
cat $HOME/.trash.log | grep $1 | while read c1 c2 c3;
do
    if [ "$c2" == "$1" ] ; then
        echo 'Restore '$c1'/'$c2' removed '$c3' (y/n)?'
       # use read
	read yes < /dev/tty
	if [[ ("$yes" != "y") && ("$yes" != "n") ]] ; then
	    #exit
	    echo "y or n next time please"
            exit 1
	    else if [[ "$yes" == "y" ]] ; then
            # check dir 
		restorepath=$c1
		if [ ! -d "$restorepath" ]; then
		    echo 'directory '$restorepath' missing, atempting to restore into '$HOME'/'
		    restorepath=$HOME
		fi
		restorefile=$restorepath'/'$c2
               # check name
		while true; do
     	            if [ -e $restorefile ] ; then
		        echo $restorefile' already exists, choose another name:'
		        read newfilename < /dev/tty
		        restorefile=$restorepath'/'$newfilename
  		    else
		        break
		    fi
		done
                # restore file
		mv $HOME/.trash/$c3 $restorefile 2>/dev/null
		if [ $? -ne 0 ]
		then
		    echo "error restoring file"
		    exit 1
		fi

                # clear log
		sed -i "/$c2/d" $HOME/.trash.log 2>/dev/null
		if [ $? -ne 0 ]
		then
		    echo "error clearing trash log"
		    exit 1
		fi
		echo $c2' restored as '$restorefile
    	    fi
	fi
    fi
done

exit 0
