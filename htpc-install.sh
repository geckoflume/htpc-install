#!/bin/bash
echo -e "Please type new user that will be created [user]: \c"
read user
if [ $user = "" ]; then
	user="user"
fi
adduser --disabled-password --gecos "" $user
usermod -a -G cdrom,audio,video,plugdev,users,dialout,dip,input,netdev $user
apt-get install -y software-properties-common
apt-add-repository ppa:team-xbmc/ppa -y
apt-add-repository ppa:libretro/stable -y
apt-add-repository ppa:emulationstation/ppa -y
apt-add-repository ppa:dolphin-emu/ppa -y
apt-get update
apt-get install -y kodi retroarch libretro-* emulationstation* dolphin-emu steam openbox hsetroot
apt-get -y dist-upgrade
su -c - $user "cp -R /etc/xdg/openbox ~/.config/"
su -c - $user "echo 'hsetroot -solid black' >> ~/.config/openbox/autostart"
wget -O ~/openbox-kodi-master.zip https://github.com/lufinkey/kodi-openbox/archive/master.zip
unzip ~/openbox-kodi-master.zip
bash ~/kodi-openbox-master/build.sh
dpkg -i kodi-openbox.deb
rm -rf ~/kodi-openbox-master
su -c - $user "echo '#!/bin/bash' | tee ~/.kodi-openbox/onfinish ~/.kodi-openbox/onkill > /dev/null"
su -c - $user "echo '/usr/bin/kodi-openbox-session' | tee -a ~/.kodi-openbox/onfinish ~/.kodi-openbox/onkill > /dev/null"
echo "[Seat:*]" > /etc/lightdm/lightdm.conf
echo "autologin-user=$user" >> /etc/lightdm/lightdm.conf
echo "autologin-session=kodi-openbox" >> /etc/lightdm/lightdm.conf
su -c - $user "wget -O ~/advanced-launcher.zip https://github.com/angelscry/plugin.program.advanced.launcher/archive/master.zip"
reboot
