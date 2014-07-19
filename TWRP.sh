#!/system/bin/sh

# Written by Modding.MyMind
# XDA Senior Member ©2014

# Requires Busybox, and GraphicsMagick!

# This script will port images from one device resolution to another device resolution using accurate calculations.

# This script is initially designed for porting TWRP Images across other device resolutions, but will not handle the ui.xml file.

# The ui.xml file will still need to be ported manually.

# Porting images manually goes as follows:

# 720/96=7.5
# 480/7.5=64
# From 720 width to 480 width you would change 96 to 64 for an accurate port.

# All fractions on the final value are to be rounded up or down appropriately.
# Greater than five goes up and Lesser than five goes down to the nearest integer.

# The script below will automatically handle all of this.


# Have user input both resolutions and the storage location of the images to be ported.
# If input is invalid then loop back to the function until they get it right.
BASE_DEVICE() {
	clear; echo Enter your resolution, ex. 480x800:
	read BASE_RESOLUTION
	B_RES_W=$(echo $BASE_RESOLUTION | egrep -o '[0-9]+x' | egrep -o '[0-9]+')
	B_RES_H=$(echo $BASE_RESOLUTION | egrep -o 'x[0-9]+' | egrep -o '[0-9]+')
	BASE_RESOLUTION_CHECK=$(echo $B_RES_W'x'$B_RES_H)
		if [ "$BASE_RESOLUTION" == "$BASE_RESOLUTION_CHECK" ] ; then
 			# Your Resolution
 			BASEW=$(echo $B_RES_W)
 			BASEH=$(echo $B_RES_H)
		else
			echo " "
			echo Please input correct layout for your resolution.
			echo An example would be, 480x800.
			echo " "
			echo Press ANY key when ready...
			read -n1 any_key
			clear; BASE_DEVICE
		fi
}

PORT_DEVICE() {
	clear; echo Enter their resolution, ex. 720x1280:
	read PORT_RESOLUTION
	P_RES_W=$(echo $PORT_RESOLUTION | egrep -o '[0-9]+x' | egrep -o '[0-9]+')
	P_RES_H=$(echo $PORT_RESOLUTION | egrep -o 'x[0-9]+' | egrep -o '[0-9]+')
	PORT_RESOLUTION_CHECK=$(echo $P_RES_W'x'$P_RES_H)
		if [ "$PORT_RESOLUTION" == "$PORT_RESOLUTION_CHECK" ] ; then
 			# Their Resolution
 			PORTW=$(echo $P_RES_W)
 			PORTH=$(echo $P_RES_H)
		else
			echo " "
			echo Please input correct layout for their resolution.
			echo An example would be, 720x1280.
			echo " "
			echo Press ANY key when ready...
			read -n1 any_key
			clear; PORT_DEVICE
		fi
}

IMAGE_DIRECTORY() {
	clear; echo Enter directory to the images, ex. /sdcard/TWRP:
	read PORT_IMAGES
		# Check to see if directory exists
		if [ -d "$PORT_IMAGES" ] ; then
 			P_IMAGES=$(echo $PORT_IMAGES)
		else
			echo " "
			echo $PORT_IMAGES is not a directory
			echo " "
			echo Press ANY key when ready...
			read -n1 any_key
			clear; IMAGE_DIRECTORY
		fi
}

# Begin calling on functions for user friendliness.
BASE_DEVICE
PORT_DEVICE
IMAGE_DIRECTORY

# Find the images to be ported.
clear; find $P_IMAGES -type f -iname "*.png" -o -iname "*.jpg" | while read line; do
		# Remember the directory and filename to each image.
		local FILE="$(basename "$line")"
		local FILEDIR="$(dirname "$line")"
		CHECK=$(find $FILEDIR -type f -iname $FILE | egrep -o '[0-9]+x[0-9]+' | wc -l)
		 	# Check if filename has numbers which resemble a resolution and temporarily remove them to prevent errors while porting.
		 	if [[ $CHECK -gt 0 ]]; then
		 	 	TEMPORARY_FILE=`echo $FILE | sed -e "s/[0-9]//g"`
		 	 	busybox mv -f $FILEDIR/$FILE $FILEDIR/$TEMPORARY_FILE
		 	 	# Determine original width and height of each image.
		 	 	SIZEW=$(gm identify $FILEDIR/$TEMPORARY_FILE | egrep -o '[0-9]+x' | egrep -o '[0-9]+')
		 	 	SIZEH=$(gm identify $FILEDIR/$TEMPORARY_FILE | egrep -o 'x[0-9]+' | egrep -o '[0-9]+')
		 	else
		 	 	SIZEW=$(gm identify $FILEDIR/$FILE | egrep -o '[0-9]+x' | egrep -o '[0-9]+')
		 	 	SIZEH=$(gm identify $FILEDIR/$FILE | egrep -o 'x[0-9]+' | egrep -o '[0-9]+')
		 	fi
		# Calculate old size for new size of each image.
		MODW=$(awk 'BEGIN{print "'$PORTW'"/"'$SIZEW'"}')
		NEWW=$(awk 'BEGIN{print "'$BASEW'"/"'$MODW'"}')
		MODH=$(awk 'BEGIN{print "'$PORTH'"/"'$SIZEH'"}')
		NEWH=$(awk 'BEGIN{print "'$BASEH'"/"'$MODH'"}')
		# Round fractions up and down for each image.
		FINALW=$(awk 'BEGIN{print int("'$NEWW'"+0.5)}')
		FINALH=$(awk 'BEGIN{print int("'$NEWH'"+0.5)}')
		 	if [[ $CHECK -gt 0 ]]; then
		 	 	# Add extra echo for spacing between loops
		 	 	echo " "
		 	 	echo Porting $FILE from $SIZEW'x'$SIZEH to $FINALW'x'$FINALH
		 	 	# Convert images to new size.
		 	 	gm convert $FILEDIR/$TEMPORARY_FILE -resize $FINALW'x'$FINALH'!' $FILEDIR/$TEMPORARY_FILE
		 	 	busybox mv -f $FILEDIR/$TEMPORARY_FILE $FILEDIR/$FILE
		 	else
		 	 	# Add extra echo for spacing between loops
		 	 	echo " "
		 	 	echo Porting $FILE from $SIZEW'x'$SIZEH to $FINALW'x'$FINALH
		 	 	# Convert image to new size.
		 	 	gm convert $FILEDIR/$FILE -resize $FINALW'x'$FINALH'!' $FILEDIR/$FILE
		 	fi;
done