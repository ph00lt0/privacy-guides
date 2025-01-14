#! /bin/bash

set -e
set -o pipefail

if [ "$1" = "--help" ]; then
  printf "%s\n" "Usage: cleanup.sh"
  exit 0
fi

bold=$(tput bold)
red=$(tput setaf 1)
normal=$(tput sgr0)

tput reset

sudo mount -o rw,remount /

printf "%s\n" "Cleaning up…"

sudo apt-get autoclean

sudo rm -fr /etc/ssh/*_host_* || true
sudo rm -fr /home/pi/.ssh || true
sudo rm -fr /home/pi/cleanup.sh* || true
sudo rm -fr /home/pi/test* || true
sudo rm -fr /tmp/* || true
sudo rm -fr /var/cache/apt/archives/* || true
sudo rm -fr /var/lib/dhcpcd5/* || true
sudo rm -fr /var/log/* || true
sudo rm -fr /var/tmp/* || true

printf "%s\n" "Done"

coutdown() {
  tput rc
  tput ed
  second_s="seconds"
  if [ "$1" = "1" ]; then
    second_s="second"
  fi
  printf "$bold%s$normal" "Rebooting in $1 $second_s"
}

tput sc

for ((index=10; index > 0; index--))
do
  coutdown $index
  sleep 1
done

sudo systemctl reboot
