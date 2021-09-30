#!/bin/sh

echo "Welcome to Auto-Setup Script..."\n
echo ".............................................."
USER=$(whoami)
if test "$USER" == "root" ;
then
    #########################################################################
    echo "Running the commands now, do not interrupt..."\n
    read -p "Modify Hostname...?[y/n]:" CHECK
    while $CHECK != "n" -o $CHECK != "N" -o $CHECK != "y" -o $CHECK != "Y" 
    do
        echo "Please Enter either Y or N or you can press Ctrl+C to exit the script:"
        read CHECK
    done
    if test "$CHECK" == "y" -o "$CHECK" == "Y";
    then
        echo "Please Enter the hostname:"
        read HOSTNAME
        echo "Hostname entered is: $HOSTNAME"
        read -p "Is that correct..?[y/n]:"
        while $CHECK != "n" -o $CHECK != "N" -o $CHECK != "y" -o $CHECK != "Y" 
        do
            echo "Please Enter either Y or N or you can press Ctrl+C to exit the script:"
            read CHECK
        done
        echo "Modifying Hostname now.."
        sudo echo "$HOSTNAME" > /etc/hostname
    else
        echo "No Changes Made.."
    fi
    echo "Waiting 5 seconds"
    sleep 5
    #########################################################################


    #########################################################################
    FILE="/etc/profile.d/motd.sh"
    echo "Modifying MOTD..."
    echo "Checking if MOTD file exists.."
    if test -f "$FILE";
    then
        echo "File already exists, Do you want to override..?[y/n]"
        read CHECK
        while $CHECK != "n" -o $CHECK != "N" -o $CHECK != "y" -o $CHECK != "Y" 
        do
            echo "Please Enter either Y or N or you can press Ctrl+C to exit the script:"
            read CHECK
        done
        if test "$CHECK" == "y" -o "$CHECK" == "Y";
        then
            echo "Updating Now..."
            rm $FILE
            touch $FILE
            echo "#!/bin/sh" >> /etc/profile.d/motd.sh
            echo "echo '*****************************************" >> /etc/profile.d/motd.sh
            echo "Welcome to `uname -n`" >> /etc/profile.d/motd.sh
            echo "You are logged in as `whoami`" >> /etc/profile.d/motd.sh
            echo "Note: Unauthorized Access prohibited" >> /etc/profile.d/motd.sh
            echo "*****************************************'" >> /etc/profile.d/motd.sh
        else
            echo "No Changes made..."
        fi
    fi        
    #########################################################################

    #########################################################################
    echo "Done"
    echo "Updating Now.."
    sudo yum update -y
    echo "Done, Waiting 5 seconds"
    sleep 5
    #########################################################################


    #########################################################################
    echo "Updating the Network Configuration"
    echo "Would you like to manually configure the network adapater..?[y/n]"
    read CHECK
    while $CHECK != "n" -o $CHECK != "N" -o $CHECK != "y" -o $CHECK != "Y" 
    do
        echo "Please Enter either Y or N or you can press Ctrl+C to exit the script:"
        read CHECK
    done
    if test "$CHECK" == "y" -o "$CHECK" == "Y";
    then
        echo "Doing something"
        echo "Done"
    fi
    echo "Exiting Network Configuration"
    echo "System has been configured.."
    #########################################################################

    echo "Reboot is required for any necessary changes to take place"
    echo "Would you like to reboot now..?[y/n]"
    read CHECK
    while $CHECK != "n" -o $CHECK != "N" -o $CHECK != "y" -o $CHECK != "Y" 
    do
        echo "Please Enter either Y or N or you can press Ctrl+C to exit the script:"
        read CHECK
    done
    if test "$CHECK" == "y" -o "$CHECK" == "Y";
    then
        echo "Rebooting Now.."
        sleep 2
        sudo init 6
    fi
else
    echo "Please run this code as a root"
    echo "Exiting"    
fi