#!/bin/bash
center(){
  COLS=$(tput cols)  # use the current width of the terminal.
  printf "%*s\n" "$(((${#1}+${COLS})/2))" "$1"
}
center " ________________________
/\                       |
\_|Automatic             |
  |       package        |
  |            installer |
  |                      |
  |   ___________________|_
   \_/_____________________/"
if [[ $EUID -ne 0 ]]; then
	echo "This script must be run as root"
	exit 1
fi
#Update and Upgrade
echo "Updating and Upgrading"
apt-get update && sudo apt-get upgrade -y
echo "Instaling dialog"
sudo apt-get install dialog -y
cmd=(dialog --separate-output --checklist "Please Select Software you want to install:" 22 76 16)
options=(1 "Terminator" off
         2 "Tmux" off
         3 "Visual Studio Code" off
         4 "Git" off
         5 "ROS Melodic" off
         6 "Htop" off
         7 "Microsoft Teams" off)
choices=$("${cmd[@]}" "${options[@]}" 2>&1 >/dev/tty)
clear
for choice in $choices
    do
        case $choice in
            1)
                #Install Terminator
                center "Installing Terminator"
                apt install terminator  -y
                ;;
            2)
                #Install Tmux
                center "Installing Terminator"
                apt install tmux tmuxinator -y
                ;;
            3)
                #Install Visual Studio Code
                center "Installing Visual Studio Code"
                apt install code -y
                ;;
            4)
                #Install git
                center "Installing Git, please configure git later..."
                apt install git -y
                ;;
            5)
                #Install ROS
                center "Installing ROS"
                sh -c 'echo "deb http://packages.ros.org/ros/ubuntu $(lsb_release -sc) main" > /etc/apt/sources.list.d/ros-latest.list'
                apt install curl -y
                curl -s https://raw.githubusercontent.com/ros/rosdistro/master/ros.asc | sudo apt-key add -
                apt update
                apt install ros-melodic-desktop-full -y
                echo "source /opt/ros/melodic/setup.bash" >> ~/.bashrc
                source ~/.bashrc
                apt install python-rosdep python-rosinstall python-rosinstall-generator python-wstool build-essential python-rosdep -y
                sudo rosdep init
                rosdep update
                mkdir -p ~/catkin_ws/src
                ;;
            6)
                #Install Htop
                center "Installing htop"
                apt install htop -y
                ;;
            7)
                #Install Teams
                center "Installing Teams"
                center "Installing Teams"
                curl https://packages.microsoft.com/keys/microsoft.asc | sudo apt-key add -
                sh -c 'echo "deb [arch=amd64] https://packages.microsoft.com/repos/ms-teams stable main" > /etc/apt/sources.list.d/teams.list'
                apt update
                apt install teams -y
                ;;
    esac
done