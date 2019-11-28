echo ":************************************************************"
echo "Bash Script to Enforce Key-based Authentication on IN nodes"
echo "Name:Issahaku Kamil | UserID : EKAMISS"
echo "************************************************************"

#Create a backup directory,extract and append timestamp to backup filename and copy files to new backup file

file11=/etc/ssh/sshd_config

if grep -Fxq "SSHConfiBackups" /tmp
then
	exit
else
	mkdir /tmp/SSHConfigBackups
fi

ExtrTimeStamp=$(date "+%Y-%m-%d_%H-%M-%S")
touch /tmp/SSHConfigBack/SSHConfigBackup.$ExtrTimeStamp;
cp -r $file11  /tmp/SSHConfigBackups/SSHConfigBackup.$ExtrTimeStamp

echo ""
echo "Do you want to disable password authentication and enforce key-based authentication? yes/no"
echo ""
read keypas
keypas=${keypas^}
echo keypas
if [[ $keypas="yes" ]]
then
	echo "checking to see if key based authentication has already been enabled..."
	if grep -Fxq "PasswordAuthentication no" $file11
	then
		echo ""
		echo "Password Authentication has been disabled. Only key-based authenticatio allowed"
		echo ""
	else
		sed -i 's/.*PasswordAuthentication.*/PasswordAuthentication no/g' $file11
	fi
elif [[ $keypas="no" ]]
	echo ""
	echo "Aborting Operation..."
	echo ""
else
	echo "exit status=$status"
fi

