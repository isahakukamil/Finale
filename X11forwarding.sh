#Set X11Forwarding to "yes"
echo ""
echo "Please do you want to enable X11forwarding?yes/no"
echo ""
file=/ets/ssh/sshd_config
read xfor
xfor=${xfor^}
if [[ $xfor="yes" ]]
then
	echo "Setting X11forwarding to yes.."
	sed -i 's/.*X11Forwarding .*/X11Forwarding yes/g;' $file
	#Check if Action was successful
        if [[ $status =  "0" ]]
        then
                echo ""
                echo "X11fForwarding has been set to yes"
                echo ""
        elif [[ $status = "1" ]]
        then
                #Rollback if the action is not successful
                echo ""
                echo "Failed to set X11Forwarding to yes,please try again :-)"
                echo ""
                cp -r /tmp/SSHConfigBack/RootSSHConfigBackup.$ExtrTimeStamp $file
        else
                echo ""
                echo "exit status=$status"
                echo ""
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


