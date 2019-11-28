#!/bin/bash

disable_root() {
echo "****************************************************"
echo "*****Script to Disable Root Access on IN nodes******"
echo "*****Name:Issahaku Kamil | UserID : EKAMISS*********"
echo "****************************************************"

#Create a backup directory,extract and append timestamp to backup filename and copy files to new backup file

file=/etc/ssh/sshd_config
if grep -Fxq "SSHConfigBack" /tmp
then
	echo ""
	echo "The backup of /etc/ssh/sshd_config is stored in /tmp/SSHConfigBack directory...."
	echo ""

else
	mkdir /tmp/SSHConfigBack/
	echo ""
fi

if grep -Fxq "Disable_root_logs" /var/log
then 
	echo ""
	echo "Your actions will be logged in the /var/log/Disable_root_logs directory"
	echo ""
else
	mkdir /var/log/Disable_root_logs
	echo ""
	echo "Your actions will be logged in the /var/log/Disable_root_logs directory"
	echo ""
fi
ExtrTimeStamp=$(date "+%Y-%m-%d_%H-%M-%S");
echo ""
echo "Note the Date-Time-Stamp in case of a rollback:$ExtrTimeStamp"
echo ""

touch /tmp/SSHConfigBack/RootSSHConfigBackup.$ExtrTimeStamp;
cp -r $file /tmp/SSHConfigBack/RootSSHConfigBackup.$ExtrTimeStamp;

#Set the securetty file to empty to prevent direct login from any device
echo > /etc/securetty;
status="$?"
if [[ $status = "0" ]]
then
	echo ""
	echo "Securetty File has been cleared to Direct login via any device"
	echo ""
elif [[ $status = "1" ]]
then 
	echo ""
	echo "Clearing of securetty file has not been successful"
	echo ""
else
	echo ""
	echo "Exit status=$status"
	echo ""
fi

#Permit or Deny Root Login
file=/etc/ssh/sshd_config
echo ""
echo "Enter yes/no to either permit or deny Root Login"
echo ""
read permit

if [[ $permit -eq "yes" ]]
then
        sed -i 's/.*PermitRootLogin.*/PermitRootLogin '$permit'/g' $file
        status="$?"
        if [[ $status="0" ]]
        then
                echo "PermitRootLogin is set to $permit"
        elif [[ $status="1" ]]
        then
                echo "Failed to set  PermitRootLogin to $permit"
                cp -r /tmp/SSHConfigBack/RootSSHConfigBackup.$ExtrTimeStamp $file
        else
                echo "exit status=$status, Please try again"
        fi
elif [[ $permit -eq "no" ]]
then
        sed -i 's/.*PermitRootLogin.*/PermitRootLogin '$permit'/g' $file
        status="$?"
        if [[ $status="0" ]]
        then
               echo "PermitRootLogin is set to $permit"
        elif [[ $status="1" ]]
        then
                echo "Failed to set  PermitRootLogin to $permit"
                cp -r /tmp/SSHConfigBack/RootSSHConfigBackup.$ExtrTimeStamp $file
        else
                echo "exit status=$status, Please try again"
        fi
else
        echo "Please set either yes/no to continue"
fi

systemctl restart sshd
#Check if Action was successful
if [[ $status =  "0" ]]
then
        echo "..................................."
        echo "SSH has been Restarted Successfully"
        echo "..................................."
elif [[ $status = "1" ]]
then
        #Rollback if the action is not successful
        echo "........................................................"
        echo "<<<<<<<<<<<<Failed to Restart SSH..Trying again>>>>>>>>>"
        echo "........................................................"
        systemctl restart sshd

else
        echo "..................."
        echo "exit status=$status"
        echo "..................."
fi

}
