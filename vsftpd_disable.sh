#!/bin/bash
echo "*******************************************************************"
echo "Script to Disable Root Access & Anonymous Login via FTP on IN nodes"
echo "************Name:Issahaku Kamil | UserID : EKAMISS*****************"
echo "*******************************************************************"

#Create a backup directory,extract and append timestamp to backup filename and copy files to new backup file
file1=/etc/vsftpd/vsftpd.conf
file2=/etc/vsftpd/ftpusers
file3=/etc/vsftpd/user_list
file4=/etc/pam.d/vsftpd
if grep -Fxq "VSFTPDBackups" /tmp
then
	echo ""
        echo "Backup of /etc/vsftpd/vsftpd.conf is stored in /tmp/VSFTPDBackups directory"
        echo ""
else
	mkdir /tmp/VSFTPDBackups
	echo ""
        echo ""
fi

if grep -Fxq "vsftpdlogs" /var/log
then 
	echo ""
        echo "Your actions are logged in the var/logs/vsftpdlogs directory"
        echo ""
else
	mkdir /var/log/vsftpdlogs
	echo ""
        echo "Your actions are logged in the var/logs/vsftpdlogs directory"
        echo ""
fi
ExtrTimeStamp=$(date "+%Y-%m-%d_%H-%M-%S")
echo ""
echo "Note the Date-Time-Stamp in case of a rollback:$ExtrTimeStamp"
echo ""

touch /tmp/VSFTPBackups/VSFTPDBackup.$ExtrTimeStamp;
touch /tmp/VSFTPDBackups/FTPUsersBackup.$ExtrTimestamp;
touch /tmp/VSFTPDBackups/UserListBackup.$ExtrTimestamp;
cp -r $file1 /tmp/VSFTPDBackups/VSFTPDBackup.$ExtrTimeStamp
cp -r $file2 /tmp/VSFTPDBackups/FTPUsersBackup.$ExtrTimeStamp
cp -r $file3 /tmp/VSFTPDBackups/USerListBackup.$ExtrTimeStamp
#end

#Set userlist_enable to yes
sed -i 's/.* user_list .*/userlist_enable=YES/g;' $file1
status="$?"
if [[ $status="0" ]]
then
	echo ""
        echo "Userlist_enable has been successfuly set to yes"
        echo ""
elif [[ $status="1" ]]
then
	echo ""
        echo "Failed to set userlist_enable to yes"
        echo ""
else
	echo "exit status=$status"
fi
#Disable Anonymous login on FTP
echo ""
echo "Do you want to Enable Anonymous FTP? YES/NO"
echo ""
read anon
anon=${anon^^}
echo $anon
if [[ $anon="YES" ]]
then
	sed -i 's/.* anonymous_enable .*/anonymous_enable='$anon'/g' $file1
	status="$?"
	if [[ $status="0" ]]
	then
        	echo ""
        	echo "Anonymous FTP has been enabled successfully"
        	echo ""
	elif [[ $status="1" ]]
	then
        	echo ""
        	echo "Failed to enable anonymous FTP"
        	echo ""
	else
        	echo "exit status=$status"
	fi
elif [[ $anon="NO" ]]
then
	sed -i 's/.* anonymous_enable .*/anonymous_enable='$anon'/g' $file1
        status="$?"
        if [[ $status="0" ]]
        then
                echo ""
                echo "Anonymous FTP has been disabled successfully"
                echo ""
        elif [[ $status="1" ]]
        then
                echo ""
                echo "Failed to disable anonymous FTP"
                echo ""
        else
                echo "exit status=$status"
        fi
fi


#Check if exists and append to config file
if grep -Fxq "user_deny=YES" $file1
then
	echo ""
        echo "USER DENY has been successfully set to yes"
        echo ""
else
	echo "user_deny=YES" >> $file1
fi

if grep -Fxq "root" $file2
then
        echo ""
        echo "root user has been successfully added to the ftpuser config file"
        echo ""
else
        echo "root" >> $file2
fi      

if grep -Fxq "root" $file3
then
        echo ""
        echo "root user has been successfully added to the user_list config file"
     	echo ""
else
        echo "root" >> $file3
fi

#Check if Action was successful
systemctl restart vsftpd
if [[ $status =  "0" ]]
then
        echo "......................................"
        echo "VSFTPD has been Restarted Successfully"
        echo "......................................"
elif [[ $status = "1" ]]
then
        #Rollback if the action is not successful
        echo "..........................................................."
        echo "<<<<<<<<<<<<Failed to Restart VSFTPD..Trying again>>>>>>>>>"
        echo "..........................................................."
        systemctl restart sshd

else
        echo "..................."
        echo "exit status=$status"
        echo "..................."
fi




