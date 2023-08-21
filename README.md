# Windows-Wallpapers [legacy]

## Introduction
This script was designed to simplify the process of extracting Windows 
wallpapers from your system's disk while you're in a Linux session. 

## Motivation
The Windows-Wallpapers Extractor was born out of the need to streamline the retrieval of Windows wallpapers, particularly the elusive lock screen images. It saves you from the hassle of manually locating and copying them.

## Usage

Edit *settings* according to your specific needs (I filed mine here just as an example):

1) Directory to paste the wallpeapers=/root/Desktop/MyFolder
2) Mount point=/media/root/OS/
3) Windows wallpeapers folder=/media/root/OS/Users/thomas/AppData/Local/Packages/Microsoft.Windows.ContentDeliveryManager_cw5n1h2txyewy/LocalState/Assets/

Just download the script, and give it permission to be executed:

<pre>chmod +x</pre>

and run it like

<pre>./main.sh</pre>

You can also edit the *blacklist* to avoid downloading ads (they used to be located in the same folder for some reason).
