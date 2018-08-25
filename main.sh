#!/usr/bin/env bash

. ./config.txt

mount_OS() # Mount Windows partition
{
	dev=$( select_dev )
	is_mounted=`sudo mount | grep "$dev"` # The command will return some value if it's mounted

	if [ ! -n "$is_mounted" ] # so if we don't get any output, the partition is not mounted.
	then
		if [ ! -d "$mount_point" ] # If there's not already a directory/folder, then create it.
		then
			sudo mkdir $mount_point
		fi
		sudo mount "$dev" "$mount_point" # Ok, now mount it!
	fi
}

select_wallpapers() # Choose files to be copied by using metadata from the files and our list of exception (unwanted files).
{
	exception_lst=`cat darklist.txt` # This list contains some unwanted files. 

	cd $copy_from
	wallpaper_lst=`file * | grep JPEG | cut -d':' -f 1`
	for img in ${exception_lst[@]}
	do
		wallpaper_lst=("${wallpaper_lst[@]/$img}") # removes exceptions from the array of file names
	done

	echo $wallpaper_lst
}

copy_wp()
{
	wallpaper_lst=$( select_wallpapers )  # Copy only wallpaper files

	cd $copy_from
	if [ ! -d $paste_to ]
	then
		sudo mkdir $paste_to
	fi
	for img in ${wallpaper_lst[@]}
	do
		sudo cp --update $img $paste_to # Copy only the new images.
	done
	sudo chmod -R 664 $paste_to # Let's give permissions to read and write, so the user is allowed to delete the files
}

select_dev() # Select our Windows device. A device name in fdisk refers to the entire disk partition.
{
    echo `sudo fdisk -l | grep "Microsoft basic data" | cut -d' ' -f 1` # example: /dev/sbd3
}

mount_OS # the partition also can be mounted manualy (open up a file manager and then click on "OS")
copy_wp
