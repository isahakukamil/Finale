echo ":********************************************************************"
echo "Script to Restrict Concurrent Unauthenticated User Access on IN nodes"
echo "***************Name:Issahaku Kamil | UserID : EKAMISS****************"
echo "*********************************************************************"

#Create a backup directory,extract and append timestamp to backup filename and copy files to new backup file
file5=/etc/ssh/sshd_config
if grep -Fxq "SSHConfiBack" /tmp
then
	echo ""
        echo "Backup of /etc/ssh/sshd_config is stored in  /tmp/SSHConfigBack directory"
	echo ""

else
	mkdir /tmp/SSHConfigBack
        echo "Backup of /etc/ssh/sshd_config is stored in /tmp/SSHConfigBack directory"
fi

#Extract Timestamp
ExtrTimeStamp=$(date "+%Y-%m-%d_%H-%M-%S")
echo ""
echo "Note the Date-Time-Stamp in case of a rollback:$ExtrTimeStamp"
echo ""
touch /tmp/SSHConfigBack/RootConfigBackup.$ExtrTimeStamp;
cp -r $file5 /tmp/SSHConfigBack/RootSSHConfigBackup.$ExtrTimeStamp

#Set The Maximum Number of SSH Authentication Tries
echo ""
echo "Please Enter a value to set the maximum number of Unthentication Retries per Login."
echo ""
read maxuth
echo "Do you want to set the Maximum Authentication Retries to $maxuth times? yes/no"
read setuth
setuth=${setuth^^}
echo $setuth
if [[ $setuth="YES" ]]
then
	echo ""
	sed -i 's/.*MaxAuthTries.*/MaxAuthTries '$maxuth'/g' $file5
	echo ""
	status="$?"
	if [[ $status="0" ]]
	then
		echo ""
		echo "Maximum Number of Authentication Tries is set to $maxuth times"
		echo ""
	elif [[ $status="1" ]]
	then
		echo ""
		echo "Failed to set MaxAuthTries. Please try again"
		echo ""
		cp -r /tmp/SSHConfigBack/RootSSHConfigBackup.$ExtrTimeStamp $file5 
	else
		echo "exit status=$status"
	fi
elif [[ $setuth="NO" ]]
then
	echo ""
	echo "No MaxAuthTries value set"
	echo ""
else
	echo "exit status=$status"
fi

#Set The Maximum Number of SSH Sessions Allowed 
echo ""
echo "Please Enter a value to set the maximum number of SSH sessions allowed."
echo ""
read sessval
echo "Do you want to set the Maximum SSH sessions to $sessval ? yes/no"
read sess
sess=${sess^^}
echo $sess
if [[ $sess="YES" ]]
then
        echo ""
        sed -i 's/.*MaxSessions.*/MaxSessions '$sessval'/g' $file5
        echo ""
        status="$?"
        if [[ $status="0" ]]
        then
                echo ""
                echo "Maximum Number of SSH Session is set to $sessval"
                echo ""
	elif [[ $status="1" ]]
	then
		echo ""
		echo "Failed to set max number of allowed SSH sessions to $sessval"
		echo ""
		echo "Initiating Rollback..."
		cp -r /tmp/SSHConfigBack/RootSSHConfigBackup.$ExtrTimeStamp $file5

	else
		echo "exit status=$status"
	fi
elif [[ $sess="NO" ]]
then
	echo ""
	echo "Aborting.."
	echo ""
else
	echo "exit status=$status"
fi

#set Maximum number concurrent Unauthenticated Connections
echo ""
echo "Please Enter a value to set the maximum number of concurrent unauthenticated connections allowed."
echo ""
read connval
echo "Do you want to set the Maximum SSH sessions to $connval? yes/no"
read conn
conn=${conn^^}
echo $conn
if [[ $conn="YES" ]]
then
        echo ""
        sed -i 's/.*MaxStartups.*/MaxStartups '$sessval'/g' $file5
        echo ""
        status="$?"
        if [[ $status="0" ]]
        then
                echo ""
                echo "Maximum Number of Concurrent Sessions is set to $connval"
                echo ""
        elif [[ $status="1" ]]
 	then
                echo ""
                echo "Failed to set max number of concurrent SSH sessions to $connval"
                echo ""
		echo "Initiating Rollback..."
		cp -r /tmp/SSHConfigBack/RootSSHConfigBackup.$ExtrTimeStamp $file5
        else
                echo "exit status=$status"
        fi
elif [[ $conn="NO" ]]
then
        echo ""
        echo "Aborting.."
        echo ""
else
        echo "exit status=$status"
fi

#Restart SSH SERVICE
systemctl restart sshd;
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





























