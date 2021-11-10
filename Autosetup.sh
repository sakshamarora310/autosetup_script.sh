#!/bin/sh

echo "##########################################  Welcome to Auto-Setup Script  ##########################################"
echo "##########################################  Author: Saksham Arora         ##########################################"
echo "##########################################  Date: 30/10/2021              ##########################################"
echo "---------------------------------------------------------------"
echo "CAUTION: THIS SCRIPT RUNS BEST ON CENTOS, RHEL OS or"
echo "SYSTEMS BASED ON SAME ARCHITECTURE.."
echo "PLEASE PRESS CTRL+C TO EXIT NOW...."
echo "I TAKE NO RESPONSIBILITY IF YOUR MACHINE CRASHES WHATSOEVER"
echo "---------------------------------------------------------------"
USER=$(whoami)
if [[ "$@" == "-h" || "$@" == "--help" ]]
then
    echo ""
    echo "Usgae: ./autosetup.sh"
    echo "This script will change hostname, motd and do some housekeeping of the machine"
    echo "Note: Please run this script as a root system.."
    echo ""
    exit 1
else
    if test "$USER" == "root" ;
    then
        ################################### Hostname Modification   ######################################

        echo "Running the commands now, You can press Ctrl+C anytime to exit the script "
        read -p "Modify Hostname...?[y/n]:" CHECK
        until [[ "$CHECK" == "n" || "$CHECK" == "N" || "$CHECK" == "y" || "$CHECK" == "Y" ]]
        do
            read -p "Please Enter either Y or N or you can press Ctrl+C to exit the script:" CHECK
        done
        if [[ "$CHECK" == "y" || "$CHECK" == "Y" ]]
        then
            HOSTNAME=""
            HOST_CHECK="N"
            until [[ "$HOST_CHECK" == "y" || "$HOST_CHECK" == "Y" ]]
            do
                read -p "Please Enter the Hostname or Press E to exit:" HOSTNAME
                if [[ "$HOSTNAME" == "E" || "$HOSTNAME" == "e" ]]
                then
                    echo "Skipping Hostname...."
                    HOST_CHECK="y"
                elif [ "$HOSTNAME" == "" ]
                then
                    echo ""
                    echo "Hostname cannot be empty.."
                    echo ""
                    HOST_CHECK="n"
                else
                    echo "Hostname entered is: $HOSTNAME"
                    read -p "Is that correct..?[y/n]:" HOST_CHECK
                    if [[ "$HOST_CHECK" == "Y" || "$HOST_CHECK" == "y" ]]
                    then
                        echo ""
                        echo "Changign Hostname Now.."
                        echo ""
                        sudo echo "$HOSTNAME" > /etc/hostname
                        HOST_CHECK="y"
                    fi
                fi 
            done
        fi
        echo ""
        echo "No Changes Made..."
        echo "Waiting for 3 seconds"
        echo ""
        $(sleep 3)
        #########################################################################


        #########################################################################

        FILE="/etc/profile.d/motd.sh"
        echo "Checking if MOTD file exists.."
        if [ -f "$FILE" ]
        then
            FILE_CHECK=""
            echo "File already exists, The content of the file is as follows..."
            echo ""
            echo "---------------------------------------------------------------"
            echo ""
            cat "$FILE"
            echo ""
            echo "These are the file contents of the motd file..."
            echo ""
            echo "---------------------------------------------------------------"
            echo ""
            read -p "Do you want to override..?[y/n]" FILE_CHECK
            until [[ "$FILE_CHECK" == "n" || "$FILE_CHECK" == "N" || "$FILE_CHECK" == "y" || "$FILE_CHECK" == "Y" ]] 
            do
                echo ""
                read -p "Please Enter either Y or N or Press Ctrl+C to exit the script:" FILE_CHECK
                echo ""
            done
        else
            echo ""
            echo "No MOTD File Found.."
            echo "Wiritng the File Now.."
            #echo "Please Select the 'Change Hostname' Option from Main Menu to change this default MOTD.."
            echo "Please Update the /etc/profile.d/motd.sh File incase you wanna change this MOTD"
            echo ""
            $(sleep 2)
            FILE_CHECK="y"
        fi
        if [[ "$FILE_CHECK" == "y" || "$FILE_CHECK" == "Y" ]]
        then
            echo ""
            echo "Modifying MOTD Now..."
            echo ""
            if [ -f "$FILE" ]
            then
                rm $FILE
            fi
            echo "#!/bin/sh" >> $FILE
            echo 'echo "*****************************************' >> $FILE
            echo "Welcome to `uname -n`" >> $FILE
            echo "You are logged in as `whoami`" >> $FILE
            echo "Note: Unauthorized Access prohibited" >> $FILE
            echo '*****************************************"' >> $FILE
        else
            echo ""
            echo "No Changes made..."
            echo ""
        fi
        echo "Done"

        #########################################################################

        #########################################################################

        echo ""
        echo "Checking if SSHD Banner is enabled.."
        output=$(cat /etc/ssh/sshd_config | grep '#Banner')
        if [ "$output" == "" ]
        then
            echo "Banner Found "
            echo "$output"
            until [[ "$banner_check" == "Y" || "$banner_check" == "y" || "$banner_check" == "N" || "$banner_check" == "n" ]]
            do
                read -p "Modifying the Banner..[Y/N]?" banner_check
            done
            if [[ "$banner_check" == "Y" || "$banner_check" == "y" ]]
            then
                banner_change="true"
            else
                banner_change="false"
            fi
        else
            echo ""
            echo "No Banner Found.."
            echo "Installing a default Banner.."
            banner_change == "true"
            echo ""
        fi
        if [ "$banner_change" == "true" ]
        then
            sed -i 's/#Banner none/Banner \/etc\/ssh\/banner/g' /etc/ssh/sshd_config
            banner_file="/etc/ssh/banner"
            echo "#!/bin/sh" >> $banner_file
            echo 'echo "*****************************************' >> $banner_file
            echo "Welcome to `uname -n`" >> $banner_file
            echo "Note: Unauthorized Access prohibited" >> $banner_file
            echo '*****************************************"' >> $banner_file
            echo ""
            echo "Banner has been Added SuccessFully.."
            echo "We have to restart the SSHD Service for the changes to take place"
            until [[ "$ssh_check" == "Y" || "$ssh_check" == "y" || "$ssh_check" == "N" || "$ssh_check" == "n" ]]
            do
                echo ""
                read -p "Restart the SSH Service Now..[Y/N]?" ssh_check
                echo ""
            done
            if [[ "$ssh_check" == "Y" || "$ssh_check" == "y" ]]
            then
                systemctl restart sshd
            fi
            echo ""
        fi
        echo ""
        echo "Waiting 3 seconds, before resuming"
        $(sleep 3)

        #########################################################################
        
        echo "System is being updated..."
        sudo dnf update -y
        echo "Done, Waiting 3 seconds before proceeding further"
        $(sleep 3)

        #########################################################################

        #########################################################################

        echo ""
        echo "Doing some housekeeping checks"
        echo ""
        sudo dnf install epel-release python3 -y
        $(sleep 1)

        #########################################################################

        #########################################################################

        echo ""
        echo "Reboot is required for any necessary changes to take place"
        read -p "Would you like to reboot now..?[y/n]" reboot_chek

        until [[ $reboot_chek == "n" || $reboot_chek == "N" || $reboot_chek == "y" || $reboot_chek == "Y" ]] 
        do
            echo "Please Enter either Y or N or you can press Ctrl+C to exit the script:"
            read CHECK
        done
        if [[ "$CHECK" == "y" || "$CHECK" == "Y" ]]
        then
            echo "Rebooting Now.."
            $(sleep 2)
            $(sudo init 6)
        fi
    else
        echo "Please run this code as a root"
        echo "Exiting"    
    fi
fi
