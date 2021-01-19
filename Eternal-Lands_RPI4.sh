#!/bin/bash
#Install Dependencies
if [ $(dpkg-query -W -f='${Status}' libcal3d12-dev libpng12-0 libsdl2-image-dev libvorbis-dev libopenal-dev libxml2-dev nlohmann-json-dev innoextract libsdl2-net-dev libsdl2-ttf-dev unzip 2>/dev/null | grep -c "ok installed") -eq 0 ];
then
  sudo apt install libcal3d12-dev libpng12-0 libsdl2-image-dev libvorbis-dev libopenal-dev libxml2-dev nlohmann-json-dev innoextract libsdl2-net-dev libsdl2-ttf-dev unzip -y;
fi

#Git Clone
cd ~
git clone https://github.com/raduprv/Eternal-Lands.git

#Build Binary
cd /home/pi/Eternal-Lands
mkdir build && cd build
cmake ../ -DJSON_FILES=0
make -j4

#Install Game
cd /home/pi/Eternal-Lands/build
wget http://www.eternal-lands.com/el_195_install.exe
innoextract /home/pi/Eternal-Lands/build/el_195_install.exe
mv /home/pi/Eternal-Lands/build/app/ /home/pi/Eternal-Lands/build/Eternal-Lands
wget http://www.gm.fh-koeln.de/~linke/EL-Downloads/EL_sound_191.zip
unzip /home/pi/Eternal-Lands/build/EL_sound_191.zip
mv /home/pi/Eternal-Lands/build/sound/ /home/pi/Eternal-Lands/build/Eternal-Lands
mv /home/pi/Eternal-Lands/build/el.linux.bin /home/pi/Eternal-Lands/build/Eternal-Lands/
sudo mv /home/pi/Eternal-Lands/build/Eternal-Lands /opt

#Create Icon
cat <<EOF >/home/pi/Desktop/Eternal-Lands.desktop
[Desktop Entry]
Version=1.0
Type=Application
Name=Eternal-Lands
Comment=Eternal-Lands
Exec=/opt/Eternal-Lands/el.linux.bin
Icon=/opt/Eternal-Lands/elc.ico
Path=/opt/Eternal-Lands
Terminal=false
StartupNotify=false
Categories=Game;
EOF

chmod +x /home/pi/Desktop/Eternal-Lands.desktop
sudo cp /home/pi/Desktop/Eternal-Lands.desktop /usr/share/applications
cd ~
rm -rf /home/pi/Eternal-Lands/