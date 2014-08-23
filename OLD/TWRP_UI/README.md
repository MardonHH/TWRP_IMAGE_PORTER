TWRP_UI_PORTER
=================

Written by Modding.MyMind
XDA Senior Member ©2014

# Requires Busybox

This script will port the ui.xml from one device resolution to another device resolution using accurate calculations.

This script is initially designed for porting TWRP ui's across other device resolutions, but will not handle the TWRP images.

Porting the ui.xml manually goes as follows:

x="96"

720/96=7.5
480/7.5=64
From 720 width to 480 width you would change x="96" to x="64" for an accurate port.

All fractions on the final value are to be rounded up or down appropriately.

Greater than five goes up and Lesser than five goes down to the nearest integer.

There are many values which need to be taken in to consideration such as x=, y=, w=, h=, width=, height= and value=.

This script WILL NOT PORT the keyboardtemplate found inside the ui file.

Such values which I am referring to are long01=, or key01=. These are examples and after trying with sed, egrep, awk and so forth I ultimately failed so please make sure you manually port them after using this script - it won't take that long.

Please insure you change the font size accordingly to your device. This script WILL NOT do it for you.