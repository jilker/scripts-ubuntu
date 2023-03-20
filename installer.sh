#!/bin/bash
center() {
    COLS=$(tput cols) # use the current width of the terminal.
    printf "%*s\n" "$(((${#1} + COLS) / 2))" "$1"
}
center " ________________________
/\                       |
\_|Automatic             |
  |       package        |
  |            installer |
  |                      |
  |   ___________________|_
   \_/_____________________/"
case $(lsb_release -sr) in
18.04)
    ros_version="melodic"
    ;;
20.04)
    ros_version="noetic"
    ;;
*) ;;
esac
#Update and Upgrade
echo "Updating and Upgrading"
sudo apt-get update && sudo apt-get upgrade -y
echo "Instaling dialog"
sudo sudo apt-get install dialog -y
cmd=(dialog --separate-output --checklist "Please Select Software you want to install:" 22 76 16)
options=(1 "Terminator" off
    2 "Tmux" off
    3 "Visual Studio Code" off
    4 "Git" off
    5 "ROS Melodic" off
    6 "Htop" off
    7 "Microsoft Teams" off
    8 "Google Chrome" off
    9 "Python3 PIP" off)
choices=$("${cmd[@]}" "${options[@]}" 2>&1 >/dev/tty)
clear
for choice in $choices; do
    case $choice in
    1)
        #Install Terminator
        center "Installing Terminator"
        sudo apt install terminator -y
        ;;
    2)
        #Install Tmux
        center "Installing Terminator"
        sudo apt install tmux tmuxinator -y
        ;;
    3)
        #Install Visual Studio Code
        center "Installing Visual Studio Code"
        sudo apt install code -y
        ;;
    4)
        #Install git
        center "Installing Git, please configure git later..."
        sudo apt install git -y
        ;;
    5)
        #Install ROS
        center "Installing ROS"
        sh -c 'echo "deb http://packages.ros.org/ros/ubuntu $(lsb_release -sc) main" > /etc/apt/sources.list.d/ros-latest.list'
        sudo apt install curl -y
        curl -s https://raw.githubusercontent.com/ros/rosdistro/master/ros.asc | sudo apt-key add -
        sudo apt update
        sudo apt install ros-"${ros_version}"-desktop-full -y
        echo "source /opt/ros/${ros_version}/setup.bash" >>~/.bashrc
        source ~/.bashrc
        sudo apt install python3-rosdep python3-rosinstall python3-rosinstall-generator python3-wstool build-essential -y
        sudo rosdep init
        rosdep update
        mkdir -p ~/catkin_ws/src
        ;;
    6)
        #Install Htop
        center "Installing htop"
        sudo apt install htop -y
        ;;
    7)
        #Install Teams
        center "Installing Teams"
        curl https://packages.microsoft.com/keys/microsoft.asc | sudo apt-key add -
        sh -c 'echo "deb [arch=amd64] https://packages.microsoft.com/repos/ms-teams stable main" > /etc/apt/sources.list.d/teams.list'
        sudo apt update
        sudo apt install teams -y
        ;;
    8)
        #Install Google Chrome
        wget https://dl.google.com/linux/direct/google-chrome-stable_current_amd64.deb
        dpkg -i google-chrome-stable_current_amd64.deb
        rm google-chrome-stable_current_amd64.deb
        ;;
    9)
        #Install pip
        center "Installing pip"
        sudo apt install python3-pip -y
        ;;
    esac
done
