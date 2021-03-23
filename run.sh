#!/usr/bin/env bash

# Reset
Color_Off='\033[0m'       # Text Reset

# Regular Colors
Black='\033[0;30m'        # Black
Red='\033[0;31m'          # Red
Green='\033[0;32m'        # Green
Yellow='\033[0;33m'       # Yellow
Blue='\033[0;34m'         # Blue
Purple='\033[0;35m'       # Purple
Cyan='\033[0;36m'         # Cyan
White='\033[0;37m'        # White

# Bold
BBlack='\033[1;30m'       # Black
BRed='\033[1;31m'         # Red
BGreen='\033[1;32m'       # Green
BYellow='\033[1;33m'      # Yellow
BBlue='\033[1;34m'        # Blue
BPurple='\033[1;35m'      # Purple
BCyan='\033[1;36m'        # Cyan
BWhite='\033[1;37m'       # White
RED='\033[0;31m'
NC='\033[0m'

showmenu() {
    echo -e "${BGreen}Simple Install Jenkins With one command , Select Distro Linux for install :"
    echo -e "${Cyan} Date : $(date)"
    echo " 1 - centos7"
    echo " 2 - ubuntu or debian"
    echo " 3 - Example Jenkinsfile"
}

success(){
    echo -e "${BGreen} 1. Access http://your_ip:8080"
    echo -e "${BGreen} 2. Run Command sudo cat /var/lib/jenkins/secrets/initialAdminPassword"
    echo -e "${BGreen} 3. Copy And Paste password for unlock jenkins"
    echo -e "${BGreen} 4. Install Suggested Plugins"
    echo -e "${BGreen} 6. set username and password"
    echo -e "${BGreen} 7. set Url and Port jenkins"
    echo -e "${BGreen} 5. Done!"
}

centos7() {
    date
    echo -e "${Purple} Install Java ...."
    echo -e "${Cyan}Input Password :" | sudo yum install java-1.8.0-openjdk-devel -y # Installing Java
    sleep .5
    echo -e "${Purple} Add the key and source ...."
    curl --silent --location http://pkg.jenkins-ci.org/redhat-stable/jenkins.repo | sudo tee /etc/yum.repos.d/jenkins.repo
    sudo rpm --import https://jenkins-ci.org/redhat/jenkins-ci.org.key
    sudo rpm --import https://pkg.jenkins.io/redhat-stable/jenkins.io.key
    sleep .5
    echo -e "${Purple} Install Jenkins ...."
    sudo yum install jenkins -y
    sudo systemctl start jenkins
    sudo systemctl enable jenkins
    sleep .5
    echo -e "${Purple} Add Access Docker for Jenkins ...."
    sudo usermod -a -G docker jenkins
    echo -e "${BGreen} Success Install Jankins on Centos7!!!"
    sleep .5
    echo -e "${Purple} Check Jenkins ...."
    sudo systemctl restart jenkins.service
    sudo systemctl status jenkins.service -l
    echo "Open firewall"
    sudo firewall-cmd --permanent --zone=public --add-port=8080/tcp
    sudo firewall-cmd --reload
    sleep .5
    success
}

ubuntu(){
    date
    echo -e "${Purple} Install Java ...."
    # echo -e "${Cyan}Input Password :" | sudo apt-get install openjdk-8-jdk -y # Installing Java
    echo -e "${Cyan}Input Password :" | sudo apt install default-jdk -y # Installing Java
    wget -q -O - https://pkg.jenkins.io/debian-stable/jenkins.io.key | sudo apt-key add -
    echo -e "${Purple} Add the key and source ...."
    sudo sh -c 'echo deb http://pkg.jenkins.io/debian-stable binary/ > /etc/apt/sources.list.d/jenkins.list'
    sudo apt update
    sleep .5
    echo -e "${Purple} Install Jenkins ...."
    sudo apt update
    sudo apt install jenkins
    echo -e "${Purple} Check Jenkins ...."
    sudo systemctl start jenkins
    sudo systemctl status jenkins.service -l
    echo "Open firewall"
    sudo ufw allow 8080
    sudo ufw status
    echo -e "${Purple} Add Access Docker for Jenkins ...."
    sudo usermod -a -G docker jenkins
    sleep .5
    success
}

example(){
    cat ./example.txt
    echo ""
}

echo -e "${Purple}+++++++++++++++++++++++++++++++++++inu++++++++++++++++++++++++++++++++++++++++++++"
echo -e "${BRed}      __               __    __                                              "
echo -e "${BRed}     |__| ____   ____ |  | _|__| ____   ______         _______ __ __  ____   "
echo -e "${BRed}     |  |/ __ \ /    \|  |/ /  |/    \ /  ___/  ______ \_  __ \  |  \/    \  "
echo -e "${BRed}     |  \  ___/|   |  \    <|  |   |  \\___ \   /_____/  |  | \/  |  /   |  \ "
echo -e "${BRed} /\__|  |\___  >___|  /__|_ \__|___|  /____  >          |__|  |____/|___|  / "
echo -e "${BRed} \______|    \/     \/     \/       \/     \/                            \/  "
echo -e "${Purple}=============================Jenkins-Installer===================================="

while true; do

    showmenu    # This calls the function above.

    read -p "Enter selection: " option

    case "$option" in
        1) centos7 ;;
        2) ubuntu ;;
        3) example ;;
        *)
        echo "${RED}Invalid selection. Exiting.${NC}"
        break 
        ;;
    esac

    read -p "Enter another selection (y/n)? " cont

    case "$cont" in
        N*|n*) break ;; 
        *) continue ;;
    esac

done

echo -e "${Red}Bye :)."


# Example Pipeline Webhooks github
# - General (Ceklis Github Project and input url repository)
# - Build Triggers (Ceklis Github Hook trigger for GITScm polling)
# - Pipeline: 
#       - Definition = pipeline script from SCM
#       - SCM = GIT
#       - Repositories = input repository, cerdentials if your repo private , Branch to build (Select your branch)
# - Add jenkinsfile on your repository.
# - Go to repositori setting and add http://your_ip:8080/github-webhook/ or https://your_ip:8080/github-webhook/