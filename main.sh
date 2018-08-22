#!/usr/bin/env bash

mount_win() # Mount Windows partition
{
	# I created these labels just so the configuration file would look more friendly
	mnt_pt=$( read_config "Mount point" )
	dev=$( select_dev $type )
	is_mounted=`sudo mount | grep "$dev"` # The command will return some value if it's mounted

	 if [ ! -n "$is_mounted" ] # so if we don't get any output, the partition is not mounted.
	 then
	 	if [ ! -d "$mnt_pt" ] # If there's not already a directory/folder, then create it.
	 	then
	 		sudo mkdir $mnt_pt
	 	fi
	 	sudo mount "$dev" "$mnt_pt" # Ok, now mount it!
	 fi
}

select_wp() # Choose files to be copied by using metadata from the files and our list of exceptions (unwanted files).
{
    win_dir=$( read_config "Windows wallpeapers folder" )
	exp=`cat darklist` # list of some unwanted files the user can add

	cd $win_dir
	wp_lst=`file * | grep JPEG | cut -d':' -f 1`
	for img in ${exp[@]}
	do
	   wp_lst=("${wp_lst[@]/$img}") # removes the exception from the array of names
	done

	echo $wp_lst
}

copy_wp() # Copy only the wallpaper files
{
	win_dir=$( read_config "Windows wallpeapers folder" )
	lnx_dir=$( read_config "Directory to paste the wallpeapers" )
	cp_files=$( select_wp )

	cd $win_dir
	if [ ! -d $lnx_dir ]
	then
		sudo mkdir $lnx_dir
	fi
	for img in ${cp_files[@]}
	do
		sudo cp --update $img $lnx_dir # Copy only the new images.
	done
	sudo chmod -R 777 $lnx_dir # (this script is meant to be executed as root)
}

read_config() # Read the configurations file, taking the values on the right.
{
    echo `cat setings | grep "$1" | cut -d'=' -f 2` # The format is "my description=my value"
}

select_dev() # Select our Windows device. A device name refers to the entire disk.
{
    echo `sudo fdisk -l | grep "Microsoft basic data" | cut -d' ' -f 1` # example: /dev/sbd3
}

mount_win # the partition also can be mounted manualy (open up a file manager and then click on "OS")
copy_wp
