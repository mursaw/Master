# Master

#run this manually first as root

              *****?If running debian start from here*****

echo "deb  http://deb.debian.org/debian  stretch main" >>  /etc/apt/sources.list

echo "deb-src  http://deb.debian.org/debian  stretch main" >>  /etc/apt/sources.list

apt-get remove unscd -y

*******?if running Ubuntu start from here*****

apt-get update -y

apt-get install make curl git -y

adduser nknuser && usermod -aG sudo nknuser

Reboot and log in as nknuser

git clone https://github.com/mursaw/Master.git

cd Master

chmod +x ./main.sh

then run the following with PASSWORD as your chosen password

Sudo ./main.sh PASSWORD
