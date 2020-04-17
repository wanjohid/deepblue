-#!/bin/bash
# 
#
#  ******************* My System Information Log *********************************
#
time_stamp()
{
date +"%x at  %T"
}
# ### running processes
curr_proc()
{
	ps -eo user,pid,cmd
} # end of current running processes

### users logged in
curr_users()
{
	who | cut -d' ' -f1 
} # end of users currently logged in
#### plugged in usb devices
dev_plugin()
{
	lsusb
} #  end of usb devices currently plugged in

#### connected media
media()
{
	ls /media/$(who| awk '{print $1}')
} #  end of connected media




### Overall disk usage
disk_usage()
{
	
	df -m / 
	

}



### usage of: home dir, /bin, /sbin, /sys, /dev, /boot and the Trash folder
dir_usage()
{
	du -sh $HOME
	du -sh /bin
	du -sh /sbin
	du -sh /usr/bin
	du -sh /usr/sbin
	du -sh /lib
	du -sh /usr/lib
	du -sh /dev
	du -sh /boot
	du -sh /var/tmp
	du -sh ~/.local/share/Trash
} # 



#### network interfaces and their status
net_stat()
{
	ip -o link show 

}


#### all installed applications
installed_programs()
{
	dpkg --get-selections 	

}


#### Monitor configuration files 



#### write the changes in the running processes
write_proc()
{
	less $PATCH_FILE|grep ^\> |grep -v "ps -eo user,pid,cmd">~/proba1.txt
	while read line;do
	echo $line >/tmp/line.txt
	echo -e "\n$(date +"%x at  %T") NEW PROCESS STARTED:"
	echo "$(less /tmp/line.txt|awk 'BEGIN { FS=" "; printf "%10s\t%10s\t%10s\t \n", "USER","PID","COMMAND"; }
	{printf "%10s\t%10s\t%10s\t \n",$2,$3,$4}'  )"
	
	done <~/proba1.txt



	less $PATCH_FILE|grep ^\< |grep -v "ps -eo user,pid,cmd">~/proba1.txt
	while read line;do
	echo $line >/tmp/line.txt
	echo -e "\n$(date +"%x at  %T") PROCESS CLOSED:"
	echo "$(less /tmp/line.txt|awk 'BEGIN { FS=" "; printf "%10s\t%10s\t%10s\t \n", "USER","PID","COMMAND"; }
	{printf "%10s\t%10s\t%10s\t \n",$2,$3,$4}'  )"
	
	done <~/proba1.txt
}



### write the changes in the users that are logged in
write_user()
{
	less $PATCH_FILE|grep ^\> >~/proba1.txt
	while read line;do
	echo $line >/tmp/line.txt
	echo -e "\n$(date +"%x at  %T") NEW USER LOGGED IN:"
	echo "$(less /tmp/line.txt|awk '{ FS=" "; printf "\t\t\t\t\t%s\n", $2; }'  )"
	done <~/proba1.txt


	less $PATCH_FILE|grep ^\< >~/proba1.txt
	while read line;do
	echo $line >/tmp/line.txt
	echo -e "\n$(date +"%x at  %T") USER LOGGED OUT:"
	echo "$(less /tmp/line.txt|awk '{ FS=" "; printf "\t\t\t\t\t%s\n", $2; }'  )"
	done <~/proba1.txt
}


#### write the changes in the plugged in usb devices
write_dev()
{

	less $PATCH_FILE|grep ^\> >~/proba1.txt
	while read line;do
	echo $line >/tmp/line.txt
	echo -e "\n$(date +"%x at  %T") USB DEVICE CONNECTED:"
	echo "$(less /tmp/line.txt|awk 'BEGIN { FS=" "; printf "%10s\t%10s\t%10s\t%s \n", "BUS","DEVICE","ID","NAME"; }
	{printf "%10s\t%10s\t%10s\t%s %s %s %s \n",$3,$5,$7,$8,$9,$10,$11 }'  )"
	
	done <~/proba1.txt


	less $PATCH_FILE|grep ^\< >~/proba1.txt
	while read line;do
	echo $line >/tmp/line.txt
	echo -e "\n$(date +"%x at  %T") USB DEVICE DISCONNECTED:"
	echo "$(less /tmp/line.txt|awk 'BEGIN { FS=" "; printf "%10s\t%10s\t%10s\t%s \n", "BUS","DEVICE","ID","NAME"; }
	{printf "%10s\t%10s\t%10s\t%s %s %s %s \n",$3,$5,$7,$8,$9,$10,$11 }'  )"
	done <~/proba1.txt

}





#### write the changes in the connected media devices
write_media()
{

	less $PATCH_FILE|grep ^\> >~/proba1.txt
	while read line;do
	echo $line >/tmp/line.txt
	echo -e "\n$(date +"%x at  %T") NEW MEDIA CONNECTED:"
	echo "$(less /tmp/line.txt|awk '{ FS=" "; printf "\t\t\t\t\t%s\n", $2; }'  )"
	done <~/proba1.txt


	less $PATCH_FILE|grep ^\< >~/proba1.txt
	while read line;do
	echo $line >/tmp/line.txt
	echo -e "\n$(date +"%x at  %T") MEDIA DISCONNECTED:"
	echo "$(less /tmp/line.txt|awk '{ FS=" "; printf "\t\t\t\t\t%s\n", $2; }'  )"
	done <~/proba1.txt

}
### write the changes in the overall disk usage
write_disk()
{


	less $PATCH_FILE|grep ^\> >~/proba1.txt
	while read line;do
	
	echo $line >/tmp/line.txt
	echo -e "\n$(date +"%x at  %T") OVERALL DISK SPACE USED IN MEGABYTES CHANGED:"
	echo -e "$(less /tmp/line.txt|awk 'BEGIN { FS=" "; printf "%10s\t%10s\t%10s\t%10s\t%15s\t\n", "TOTAL SIZE","USED","AVAILABLE","USE%","FILESYSTEM"; }
	{printf "%10s\t%10s\t%10s\t%10s\t%15s\t \n",$3,$4,$5,$6,$2;}' )\n"
	done <~/proba1.txt
}
### write the changes in the usage of /home , /bin, /usr/bin, /usr/sbin, /sbin
write_usage()
{
	less $PATCH_FILE|grep ^\> >~/proba1.txt
	while read line;do
	echo $line >/tmp/line.txt
	echo -e "\n$(date +"%x at  %T") USAGE FOR THE FOLLOWING DIRECTORY CHANGED TO:"
	echo "$(less /tmp/line.txt|awk 'BEGIN { FS=" "; printf "%10s\t%10s\t \n", "SIZE","DIRECTORY"; }
	{printf "%10s\t%10s\t \n",$2,$3 }'  )"
	done <~/proba1.txt

	less $PATCH_FILE|grep ^\< >~/proba1.txt
	while read line;do
	echo $line >/tmp/line.txt
	echo -e "OLD VALUES WERE:"
	echo "$(less /tmp/line.txt|awk 'BEGIN { FS=" "; printf "%10s\t%10s\t \n", "SIZE","DIRECTORY"; }
	{printf "%10s\t%10s\t \n",$2,$3 }'  )"
	done <~/proba1.txt


}


### write the changes in the network interface and their status
write_net()
{


	less $PATCH_FILE|grep ^\> >~/proba1.txt
	while read line;do
	echo $line >/tmp/line.txt
	echo -e "\n$(date +"%x at  %T") CHANGE IN NETWORK INTERFACE: \n"
	echo -e "$(less /tmp/line.txt|awk 'BEGIN { FS=" "; printf "%10s\t%10s\t%10s\t%10s\t%10s\t%10s\t \n", "Name","MTU","QDISK","STATE","MODE","QLAN"; }
	{printf "%10s\t%10s\t%10s\t%10s\t%10s\t%10s\t \n",$3,$6,$8,$10,$12,$16;}' )\n"
	done <~/proba1.txt



	less $PATCH_FILE|grep ^\< >~/proba1.txt
	while read line;do

	echo $line >/tmp/line.txt
	echo -e "OLD VALUES WERE: \n"
	echo -e "$(less /tmp/line.txt|awk 'BEGIN { FS=" "; printf "%10s\t%10s\t%10s\t%10s\t%10s\t%10s\t \n", "Name","MTU","QDISK","STATE","MODE","QLAN"; }
	{printf "%10s\t%10s\t%10s\t%10s\t%10s\t%10s\t \n",$3,$6,$8,$10,$12,$16;}' )\n"
	done <~/proba1.txt


}


#### write the changes in the installed APPLICATIONS
write_prog()
{


	less $PATCH_FILE|grep ^\>| grep -w install >~/proba1.txt
	while read line;do
	echo $line >/tmp/line.txt
	echo -e "\n$(date +"%x at  %T") NEW APPLICATION ISTALLED:"
	echo "$(less /tmp/line.txt|awk '{ FS=" "; printf "\t\t\t\t\t%20s\n", $2; }'  )"
	
	done <~/proba1.txt

	less $PATCH_FILE|grep ^\>| grep -w deinstall >~/proba1.txt
	while read line;do
	echo $line >/tmp/line.txt
	echo -e "\n$(date +"%x at  %T") APPLICATION UNINSTALLED:"
	echo "$(less /tmp/line.txt|awk '{ FS=" "; printf "\t\t\t\t\t%20s\n", $2; }'  )"
	
	
	done <~/proba1.txt


}


### show the usage of the script
usage()
{
    echo "usage: sudo ./MySysMonitor.sh [[-i] | [-h]]"
}


### write to html file
write_page()
{
    cat <<- _EOF_
    <html>
        <head>
        <title>$TITLE</title>
	<style>
	body {
	    background-color:   #bdc3c7;

	}
	</style>
        </head>
        <body>
        <h1 align="center" style="color:#283747">$TITLE</h1>
	<p align="center" style="color:#283747">$TIME_STAMP</p>

	
	<h3 style="float: left; color:#283747">CHANGES IN CURRENT PROCESSES </h3>
	<h3 style="float: right;  text-align: right;color:#283747">CHANGES IN USERS LOGGED IN</h3>
	<div id="list">
  	<p><iframe allowtransparency="true" style="background:  #d0d3d4 " src="/tmp/prochtml.txt" frameborder="5" height="120"
      	width="49%" align="left"></iframe>    <iframe allowtransparency="true" style="background:  #d0d3d4 " src="$user_html" frameborder="5" height="120"
      	width="49%" align="right"></iframe></p>
	</div>

	
	<h3 style="float: left; color:#283747">CHANGES IN PLUGGED USB DEVICES</h3>
	<h3 style="float: right;  text-align: right;color:#283747">CHANGES IN MEDIA DEVICES</h3>
	<div id="list">
  	<p><iframe allowtransparency="true" style="background:  #d0d3d4 " src="$usb_html" frameborder="5" height="120"
      	width="49%" align="left"></iframe>    <iframe allowtransparency="true" style="background:  #d0d3d4 " src="$media_html" frameborder="5" height="120"
      	width="49%" align="right"></iframe></p>
	</div>
	
	<h3 style="float: left; color:#283747">CHANGES IN DISK USAGE</h3>
	<h3 style="float: right;  text-align: right;color:#283747"> CHANGES TO IMPORTANT FOLDERS</h3>
	<div id="list">
  	<p><iframe allowtransparency="true" style="background:  #d0d3d4 " src="$disk_html" frameborder="5" height="120"
      	width="49%" align="left"></iframe>    <iframe allowtransparency="true" style="background:  #d0d3d4 " src="$dir_html" frameborder="5" height="120"
      	width="49%" align="right"></iframe></p>
	</div>
	
	<h3 style="float: left; color:#283747">CHANGES IN NETWORKS</h3>
	<h3 style="float: right;  text-align: right;color:#283747">CHANGES IN INSTALLED APPLICATIONS</h3>
	<div id="list">
  	<p><iframe allowtransparency="true" style="background:  #d0d3d4 " src="$net_html" frameborder="5" height="120"
      	width="49%" align="left"></iframe>    <iframe allowtransparency="true" style="background:  #d0d3d4 " src="$installed_html" frameborder="5" height="120"
      	width="49%" align="right"></iframe></p>
	</div>
	
        </body>
    </html>
_EOF_

}



###### MAIN

interactive=
sec=1

TITLE="System Information for $HOSTNAME"
RIGHT_NOW=$(date +"%x %r %Z")
TIME_STAMP="Started on $RIGHT_NOW"
PATCH_FILE="/tmp/patchFile.patch"
MY_FILE=~/MySysMonitor.log
FILENAME=~/MySysMonitor.html

temp_file="/tmp/temp.txt"
temp_file2="/tmp/temp2.txt"
temp_usr="/tmp/usr.txt"
temp_dev="/tmp/dev.txt"
temp_med="/tmp/media.txt"
temp_net="/tmp/net.txt"
temp_usage="/tmp/usage.txt"
temp_disk="/tmp/disk.txt"
temp_prog="/tmp/prog.txt"
temp_usr2="/tmp/usr2.txt"
temp_dev2="/tmp/dev2.txt"
temp_net2="/tmp/net2.txt"
temp_disk2="/tmp/disk2.txt"
temp_usage2="/tmp/usage2.txt"
temp_prog2="/tmp/prog2.txt"
temp_med2="/tmp/media2.txt"

proc_html="/tmp/prochtml.txt"
user_html="/tmp/userhtml.txt"
usb_html="/tmp/usbhtml.txt"
media_html="/tmp/mediahtml.txt"
disk_html="/tmp/diskhtml.txt"
dir_html="/tmp/dirhtml.txt"
net_html="/tmp/nethtml.txt"
installed_html="/tmp/installedhtml.txt"
trap "rm $PATCH_FILE;rm $temp_file;rm $proc_html;rm $user_html;rm $usb_html;rm $media_html;rm $disk_html;rm $dir_html;rm $net_html;rm $installed_html;rm $temp_med2; rm $temp_med;rm $temp_file2; rm $temp_usr; rm $temp_usr2; rm $temp_dev; rm $temp_dev2; rm $temp_net; rm $temp_net2; rm $temp_usage; rm $temp_usage2; rm $temp_disk; rm $temp_disk2;rm $temp_prog;rm $temp_prog2; rm ~/proba1.txt;rm /tmp/net1.txt; rm /tmp/line.txt; exit" SIGHUP SIGINT SIGTERM
while [ "$1" != "" ]; do
    case $1 in
        
        -i | --interactive )    interactive=1
                                ;;
        -h | --help )           usage
                                exit
                                ;;
        * )                     usage
                                exit 1
    esac
    shift
done
# Test code to verify command line processing

if [ "$interactive" = "1" ]; then
    response=

    echo -n "Enter wait period in seconds: "
    read response
    if [ -n "$response" ]; then
        sec=$response
    fi
  
fi

while :
do

if [ -f $temp_file ]; then
	
	curr_proc > $temp_file2
	diff $temp_file $temp_file2 > $PATCH_FILE
	(cd / && patch -p0 $temp_file)< $PATCH_FILE
	write_proc>> $MY_FILE
	write_proc >> $proc_html
	

	curr_users > $temp_usr2
	diff $temp_usr $temp_usr2 > $PATCH_FILE
	(cd / && patch -p0 $temp_usr)< $PATCH_FILE
	write_user>> $MY_FILE
	write_user>> $user_html
	
	dev_plugin > $temp_dev2
	diff $temp_dev $temp_dev2 > $PATCH_FILE
	(cd / && patch -p0 $temp_dev)< $PATCH_FILE
	write_dev>> $MY_FILE
	write_dev>> $usb_html

	media > $temp_med2
	diff $temp_med $temp_med2 > $PATCH_FILE
	(cd / && patch -p0 $temp_med)< $PATCH_FILE
	write_media>> $MY_FILE
	write_media>> $media_html

	disk_usage > $temp_disk2
	diff $temp_disk $temp_disk2 > $PATCH_FILE
	(cd / && patch -p0 $temp_disk)< $PATCH_FILE
	write_disk>> $MY_FILE
	write_disk>> $disk_html


	dir_usage > $temp_usage2
	diff $temp_usage $temp_usage2 > $PATCH_FILE
	(cd / && patch -p0 $temp_usage)< $PATCH_FILE
	write_usage>> $MY_FILE
	write_usage>> $dir_html

	net_stat > $temp_net2
	diff $temp_net $temp_net2 > $PATCH_FILE
	(cd / && patch -p0 $temp_net)< $PATCH_FILE
	write_net>> $MY_FILE
	write_net>> $net_html
	
	installed_programs > $temp_prog2
	diff $temp_prog $temp_prog2 > $PATCH_FILE
	(cd / && patch -p0 $temp_prog)< $PATCH_FILE
	write_prog>> $MY_FILE
	write_prog>> $installed_html
	
	
else
	
	curr_proc > $temp_file
	curr_users >$temp_usr
	dev_plugin > $temp_dev
	media > $temp_med
	disk_usage > $temp_disk
	dir_usage > $temp_usage
	net_stat > $temp_net
	installed_programs > $temp_prog
	> $MY_FILE
	echo "Waiting for something to change..." | tee $proc_html $user_html $usb_html $media_html $disk_html  $dir_html $net_html $installed_html> /dev/null
fi
	
	write_page >$FILENAME
	
sleep $sec

done
