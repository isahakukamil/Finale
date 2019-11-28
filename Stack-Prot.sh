echo "*********************************************************************"
echo "***Script to stack protection against buffer overflows on IN nodes***"
echo "************Name:Issahaku Kamil | UserID : EKAMISS*******************"
echo "************************************************************"

ExtrTimeStamp=$(date "+%Y-%m-%d_%H-%M-%S")
echo ""
echo "Note the Date-Time-Stamp in case of a rollback:$ExtrTimeStamp"
echo ""

file10=/etc/sysctl.conf

if grep -Fxq "StackBufferBak" /tmp
then
	echo "All backups are stored in /etc/sysctl.conf directory"
else
	mkdir /tmp/StackBufferBak
fi

touch /tmp/StackBufferBak/BufferOverflowBackup.$ExtrTimeStamp
cp -r $file10 /tmp/StackBufferBak/BufferOverflowBackup.$ExtrTimeStamp

#Enable Stack Protection
echo ""
echo "It is advisable to enable stack protection.Do you want to enable stack protection? yes/no"
echo ""
read stackresp
stackresp=${Stackresp^}
echo stackresp
if [[ $stackresp="yes" ]]
then
	echo "Setting kernel.exec-shield to 1 in /etc/sysctl.conf directory"
	echo "kernel.exec-shield = 1" >> /etc/sysctl.conf
	status="$?"
	if [[ $status="0" ]]
	then
		echo "Stack protection enabled"
	elif [[ $status="1" ]]
	then
		echo "Stack protection is not enabled"
	else
		echo "exit status=$status"
	fi
elif [[ $stackresp="no" ]]
then
	echo ""
	echo "Aborting Operation..."
	echo ""
else
	echo "exit status=$status"
fi


