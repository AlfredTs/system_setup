# switch touchpad to natural scrolling
sudo apt update

#undervolt
sudo apt install python3-pip
sudo pip install undervolt
sudo undervolt --core -130 --cache -130
#persistence details here https://github.com/georgewhewell/undervolt

#tools foss
sudo apt install blender gimp inkscape zim natron tee

#set hostname
echo 'cybersnake' | sudo tee /etc/hostname

#insync
sudo apt-key adv --keyserver keyserver.ubuntu.com --recv-keys ACCAF35C
echo 'deb http://apt.insync.io/ubuntu groovy non-free contrib' | sudo tee /etc/apt/sources.list.d/insync.list
sudo apt update
sudo apt install insync


#houdini
#https://www.sidefx.com/download/houdini-for-linux/ - latest
#https://www.sidefx.com/download/download-houdini/63948/ - RS compatible

#redshift3d --last licensed version
#https://www.redshift3d.com/forums/viewthread/29535/
