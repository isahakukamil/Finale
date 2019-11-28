echo "************************************************************"
echo "**********Script to Remove cgi scripts on IN nodes**********"
echo "*********Name:Issahaku Kamil | UserID : EKAMISS*************"
echo "************************************************************"

echo ""
echo "It is advisable according the CIS security compliance for RHEL to remove all cgi scripts present"
echo ""
echo "Do you want to remove all default cgi scripts present on th node? yes/no"
read rmscgi
rmcgi=${rmcgi^}
echo rmcgi
if [[ $rmcgi="yes" ]]
then
	echo "removing printenv cgi scripts located in the /var/apache/cgi-bin directory"
	rm /var/apache/cgi-bin/printenv
	status="$?"
	if [[ $status="0" ]]
	then
		echo "Printenv cgi scripts removed successfully"
	elif [[ $status="1" ]]
	then
		echo "Failed to remove Printenv cgi script"
	else
		echo "exit status=$status"
	fi
	
	echo "removing test-cgi scripts located in the /var/apache/cgi-bin directory"
	rm /var/apache/cgi-bin/test-cgi
	status="$?"
	if [[ $status="0" ]]
	then
        	echo "test-cgi script removed successfully"
	elif [[ $status="1" ]]
	then
        	echo "Failed to remove test-cgi script"
	else
        	echo "exit status=$status"
	fi
elif [[ $rmcgi="no" ]]
then
	echo ""
	echo "Aborting Operation ..."
	echo ""
else
	echo "exit status=$status"
fi

