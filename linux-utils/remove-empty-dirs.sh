#!/bin/sh
function remove_dir {
	dir_=$1
	echo "Removing $dir_"	
	if [ -d $dir_ ]; then
		# TODO if $dir_ is not empty, remove all from it;
		for i in $(ls $dir_); do
			remove_dir $dir_/$i
		done
		rmdir $dir_
	else
		echo "Skip non-folder path:  $dir_"
	fi
}
echo "Removing all empty dirs in directory: $@"
while [ "$1" != "" ];
do
	dir=$1
	remove_dir $dir
	shift
done
