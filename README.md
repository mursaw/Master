# Master

#run this manually first as root

echo "deb  http://deb.debian.org/debian  stretch main" >>  /etc/apt/sources.list

echo "deb-src  http://deb.debian.org/debian  stretch main" >>  /etc/apt/sources.list

apt-get remove unscd -y

apt-get update -y

apt-get install make curl git -y

adduser nknuser && usermod -aG sudo nknuser

Reboot and log in as nknuser
