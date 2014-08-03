TWRP_IMAGE_PORTER
=================

Written by Modding.MyMind
XDA Senior Member ©2014

# Requires Busybox, and GraphicsMagick!

This script will port images from one device resolution to another device resolution using accurate calculations.

This script is initially designed for porting TWRP Images across other device resolutions, but will not handle the ui.xml file.

Porting images manually goes as follows:

720/96=7.5
480/7.5=64
From 720 width to 480 width you would change 96 to 64 for an accurate port.

All fractions on the final value are to be rounded up or down appropriately.

Greater than five goes up and Lesser than five goes down to the nearest integer.

The script will automatically handle all of this.
