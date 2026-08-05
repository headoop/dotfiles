#!/usr/bin/bash

# Set some default values:
NAME="archlinux"
ISO="/home/cs/iso/archlinux-2023.03.01-x86_64.iso"
POOL="default"
TYPE="qcow2"
# virt-install --osinfo list
OSINFO="archlinux" # opensusetumbleweed archlinux fedora37 ubuntukinetic

usage()
{
  echo "Usage: qemu-create-vm [ -n | --name ubuntu ] [ -i | --iso ubuntu.iso ]
                        [ -p | --pool default ] [ -t | --type qcow2   ]
                        [ -o | --osinfo ubuntu22.10 ]
                        use 'virt-install --osinfo list' for a list of known systems"
  exit 2
}

ARGUMENTS=$(getopt -a -n qemu-create-vm -o hn:i:p:t:o: --long help,name:,iso:,pool:,type:,osinfo: -- "$@")
VALID=$?
if [ "$VALID" != "0" ]; then
  usage
fi

echo "ARGUMENTS is $ARGUMENTS"
eval set -- "$ARGUMENTS"
while :
do
  case "$1" in
    -n | --name)   NAME=$2      ; shift 2 ;;
    -i | --iso)    ISO=$2       ; shift 2 ;;
    -p | --pool)   POOL="$2"    ; shift 2 ;;
    -t | --type)   TYPE="$2"    ; shift 2 ;;
    -o | --osinfo) OSINFO=$2    ; shift 2 ;;
    -h | --help)   usage        ; shift ;;
    # -- means the end of the arguments; drop this, and break out of the while loop
    --) shift; break ;;
    # If invalid options were passed, then getopt should have reported an error,
    # which we checked as VALID_ARGUMENTS when getopt was called...
    *) echo "Unexpected option: $1 - this should not happen."
       usage ;;
  esac
done

echo starting creation ...
read -r

# create an image in the default pool
virsh vol-create-as --pool "$POOL" --capacity 25G --format "$TYPE"  --name "$NAME"."$TYPE"

# --osinfo detect=on,require=on
virt-install --name "$NAME" --memory 8196 --vcpus 4 --virt-type kvm --disk vol="$POOL"/"$NAME"."$TYPE" --cdrom "$ISO" --osinfo "$OSINFO" --boot uefi --network bridge=br0

