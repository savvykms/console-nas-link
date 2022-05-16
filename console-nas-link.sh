#!/bin/bash

cmd=$1
prog=console-nas-link
#file=/dev/sda
file=/root/usb_test

###This emuluates an external USB 3.0 3.5 inch drive enclosure that was compatible with an xbox one x
###idVendor=0bc2 idProduct=a0a4 iManufacturer=Seagate iProduct=USB iSerialNumber=2HC015KJ

function start_link()
{
  echo "Running modprobe g_mass_storage"
  modprobe g_mass_storage file=$1 removable=y stall=0
}

function stop_link()
{
  modprobe -r g_mass_storage
}

function is_running()
{
  if [[ "$(lsmod | grep g_mass_storage | wc -l)" != "0" ]]; then
    return 1;
  else
    return 0;
  fi
}

case $cmd in
  start)
      echo "Starting $prog"
      #start_link $file
      #modprobe g_mass_storage file=$file removable=y stall=0 idVendor=0bc2 idProduct=a0a4 iManufacturer=Seagate iProduct=USB iSerialNumber=2HC015KJ
      modprobe g_mass_storage file=$file removable=y stall=0 nofua=1 idVendor=0x0bc2 idProduct=0xa0a4 iManufacturer="Seagate" iProduct="USB"
      exit $?
    ;;
  stop)
      echo "Stopping $prog"
      #stop_link
      modprobe -r g_mass_storage
      exit $?
    ;;
  status)
      if is_running; then
        echo "$prog is running"
      else
        echo "$prog is stopped"
      fi
      exit 0;
    ;;
esac
