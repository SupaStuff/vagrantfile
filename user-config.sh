#!/bin/bash

username=stuff
dotfiles="https://github.com/SupaStuff/dotfiles.git --branch=dev"
dockerfiles="https://github.com/SupaStuff/dockerfiles.git"
TZ="America/New_York"

ln -s /usr/share/zoneinfo/$TZ /etc/localtime

useradd -ms /bin/bash $username || true
usermod -aG sudo $username
usermod -aG docker $username

cat << EOF >/etc/sudoers.d/99_$username
$username ALL=(ALL) NOPASSWD:ALL
EOF

mkdir -p /etc/lightdm/lightdm.conf.d
cat << EOF > /etc/lightdm/lightdm.conf.d/50-autologin.conf
[SeatDefaults]
autologin-user=$username
EOF

cd /home/$username
[[ -d dotfiles ]] || rm .bashrc
su $username -c "git clone $dotfiles || true"
cd dotfiles
su $username -c "stow * || true"
cd ..
su $username -c "git clone $dockerfiles || true"
su $username -c "mkdir stuff code || true"
su $username -c "mv Documents Downloads Music Pictures Template Videos stuff || true"
