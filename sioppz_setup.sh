#!/bin/sh

#@todo switch touchpad to natural scrolling
$do_undervolt = 1

#undervolt
sudo apt update
sudo apt install python3-pip
sudo pip install undervolt
sudo undervolt --core -130 --cache -130
echo 'Undervolt installed. Setting up persistence'
#persistence details from here https://github.com/georgewhewell/undervolt
echo '[Unit]
Description=undervolt
After=suspend.target
After=hibernate.target
After=hybrid-sleep.target

[Service]
Type=oneshot
# If you have installed undervolt globally (via sudo pip install):
ExecStart=/usr/local/bin/undervolt -v --core -130 --cache -130
# If you want to run from source:
# ExecStart=/path/to/undervolt.py -v --core -150 --cache -150 --gpu -100

[Install]
WantedBy=multi-user.target
WantedBy=suspend.target
WantedBy=hibernate.target
WantedBy=hybrid-sleep.target' | sudo tee /etc/systemd/system/undervolt.service
systemctl start undervolt
systemctl enable undervolt



#tools foss
echo '### Installing the main FOSS tools ###'
sudo apt install blender gimp inkscape zim natron tee code timeshift

#set hostname
echo -n 'What should be the hostname?'
read new_hostname
echo $new_hostname | sudo tee /etc/hostname

#insync
sudo apt-key adv --keyserver keyserver.ubuntu.com --recv-keys ACCAF35C
echo 'deb http://apt.insync.io/ubuntu groovy non-free contrib' | sudo tee /etc/apt/sources.list.d/insync.list
sudo apt update
sudo apt install insync

#cuda
echo '### Installing CUDA ###'
wget https://developer.download.nvidia.com/compute/cuda/repos/ubuntu2004/x86_64/cuda-ubuntu2004.pin
sudo mv cuda-ubuntu2004.pin /etc/apt/preferences.d/cuda-repository-pin-600
wget https://developer.download.nvidia.com/compute/cuda/11.1.1/local_installers/cuda-repo-ubuntu2004-11-1-local_11.1.1-455.32.00-1_amd64.deb
sudo dpkg -i cuda-repo-ubuntu2004-11-1-local_11.1.1-455.32.00-1_amd64.deb
sudo apt-key add /var/cuda-repo-ubuntu2004-11-1-local/7fa2af80.pub
sudo apt-get update
sudo apt-get -y install cuda
echo '### CUDA Installation done! ###'

#houdini
#based on instructions from https://www.sidefx.com/forum/topic/30779/?page=1#post-141524
echo "Starting Houdini Setup"
# SideFx login credentialsd:
echo -n "Enter SideFX username:"
read sidefx_name
echo -n "Enter SideFX password:"
read sidefx_pass

#-------------------------------------
ogdir=$(pwd)

sidefx_url="https://www.sidefx.com"
login_page="${sidefx_url}/login/"
download_page="${sidefx_url}/download/houdini-for-linux/get/"
rsversion_download_page="${sidefx_url}/download/download-houdini/63948/"

# get csrf token and csrf cookie:
echo "getting middleware token..."
csrf=`curl -s -b cookies -c cookies -s $sidefx_url | grep csrfmiddlewaretoken | sed -n "s/^.*value='\(.*\)'.*$/\1/p" | head -n1`

# Provide login credentials, save resulting cookies to text file:
echo "Logging in..."
curl -s -b cookies -c cookies --data-urlencode "password=$sidefx_pass" --data-urlencode "username=$sidefx_name" -d "submit=Login%20In&csrfmiddlewaretoken=$csrf&next=%2F" -H "Origin: ${sidefx_url}" -H "Referer: ${sidefx_url}/" $login_page


# open download page and follow redirect to CDN
echo "HOUDINI: Downloading the latest version"
curl -b cookies -c cookies -O -J -L $download_page
#untar and install
newdir=$(tar -v -zxf houdini* | sed -e 's@/.*@@' | uniq)
echo $newdir | tee result
cd "$newdir"
sudo ./houdini.install
cd ..
#clean up
rm -rf "$newdir"
rm houdini*
#source
cd /opt/hfs18.5
. houdini_setup
cd "$ogdir"

echo "HOUDINI: Downloading the RS compatible version"
curl -b cookies -c cookies -O -J -L $rsversion_download_page
tar -xvf houdini*
rm houdini*
#untar and install
newdir=$(tar -v -zxf houdini* | sed -e 's@/.*@@' | uniq)
echo $newdir | tee result
cd "$newdir"
sudo ./houdini.install
cd ..
rm -rf "$newdir"
rm houdini*
#source
cd /opt/hfs18.5
. houdini_setup
cd "$ogdir"
echo "HOUDINI: Don't forget to run source houdini in /opt/ !!!"
# curl clean up
rm cookies
#SideFX licensing
echo "Time to license!"
hkey

#redshift3d --last licensed version
#https://www.redshift3d.com/forums/viewthread/29535/


#git
git_name="sioppz"
git_email="alfred.tsaizer@gmail.com"
git_user="sioppz"

sudo apt install git xclip
git config --global user.name $git_name
git config --global user.email  $git_email
git config --global user.name $git_user
#git config --global push.default matching
git config --global color.ui true
git config --global core.editor code
ssh-keygen -t rsa -C $git_email
cat ~/.ssh/id_rsa.pub | xclip -sel clip
firefox https://github.com/settings/ssh/new