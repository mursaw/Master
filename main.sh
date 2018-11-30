#!/usr/bin/env bash
# Run only as expected
[[ ($# -ne 1) || ! $SUDO_USER ]] && echo 'Usage: sudo ./setup password' && exit 1

# User running the script and wallet pass
user=$SUDO_USER
passwd=$1
dir=$PWD
gourl=`curl https://golang.org/dl/ | grep linux-amd64 | sort --version-sort | tail -1 | grep -o -E "https://dl.google.com/go/go[0-9]+\.[0-9]+((\.[0-9]+)?).linux-amd64.tar.gz"`

# Minimal environment needed
HOME="/home/$user"



wget ${gourl}

tar -C /usr/local -xvf `echo ${gourl} | cut -d '/' -f5`

	echo "export PATH=/usr/local/go/bin:$HOME/go/bin:\$PATH" >> "$HOME/.profile"
	. "$HOME/.profile"
	echo "- Environment Path set &  reloaded, Press enter to continue"

go version

mkdir -p ~/go/src/github.com/nknorg && cd ~/go/src/github.com/nknorg

git clone https://github.com/nknorg/nkn.git --progress

cd nkn

make glide

make vendor

make

cp config.testnet.json config.json

# Wallet
addr=$(./nknc wallet -c -p "$passwd" | awk 'NR==3{print $1}')
echo "- WALLET created"


echo "Setting Plug&Play NKM..."
echo "------------------------"

# Systemd
cd "$dir"

sed -i "s/EDITNAME/$user/g" nkn.service
sed -i "s/EDITPASS/$passwd/g" nkn.service
mv nkn.service /etc/systemd/system/
echo "- Systemd service installed"

# Install nknupdate script
sed -i "s/EDITNAME/$user/g" nknupdate
mv nknupdate "~"
echo "- NKN update script installed"

# Make sure no files are owned by root
chown -R "$user:$user" "$HOME/go/src/github.com/nknorg/nkn"
chown -R "$user:$user" "$HOME/go"

chown "$user:$user" "~"


# Useful aliases and cleaning

cd $HOME
echo "alias wl='cd $HOME/go/src/github.com/nknorg/nkn; ./nknc wallet -l balance -p \"$passwd\"; cd - &>/dev/null'" >> ~/.bashrc
echo "alias ad='cd $HOME/go/src/github.com/nknorg/nkn; ./nknc wallet -l account -p \"$passwd\"; cd - &>/dev/null'" >> ~/.bashrc
echo "alias lg='sudo journalctl --follow -o cat -u nkn.service'" >> ~/.bashrc
source .bashrc


systemctl enable nkn.service &>/dev/null
echo -e "=> Plug&Play NKM set successfully\n"


## Welcome message
sleep 2
echo "                  -----------------------"
echo "                  | NEW KIND OF NETWORK |"
echo "                  -----------------------"
echo
echo "============================================================="
echo "       NKN ADDRESS: $addr"
echo "============================================================="
echo
echo "NKN dir is \$HOME/go/src/github.com/nknorg/nkn"
echo "To query the balance or account cd into NKN dir:"
echo "balance: ./nknc wallet -l balance -p password"
echo "address: ./nknc wallet -l account -p password"
echo "log: sudo journalctl --follow -o cat -u nkn.service"
echo
echo "Handy aliases:"
echo "wl - for wallet balance"
echo "lg - real-time log"
echo "ad - to access NKN address"
echo
echo "-------------------------------------------------------------"
echo "nkn service status:      systemctl status nkn.service"
echo "stop nkn service         sudo systemctl stop nkn.service"
echo "start nkn service        sudo systemctl start nkn.service"
echo "restart nkn service      sudo systemctl restart nkn.service"
echo "update nkn               sudo \$HOME/nknupdate"
echo "-------------------------------------------------------------"
echo
echo "NOW REBOOT THE DEVICE - sudo reboot"

