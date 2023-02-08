#!/bin/bash
TMPL_NAME="ubuntu-2004-cloud"
IMG_URL="https://cloud-images.ubuntu.com/releases/focal/release/ubuntu-20.04-server-cloudimg-amd64.img"
IMG_NAME="ubuntu-20.04-server-cloudimg-amd64.img"
STORAGE_NAME=SSD
MEM=1024
CORES=2
NETWORK="virtio,bridge=vmbr1"

if [ -z $1 ]
   then
        read -p "Enter id number for new template: " id
   else
        id=$1
fi

wget $IMG_URL

qm create $id --name $TMPL_NAME --memory $MEM --cores $CORES --net0 $NETWORK
qm importdisk $id $IMG_NAME $STORAGE_NAME
qm set $id --scsihw virtio-scsi-pci --scsi0 $STORAGE_NAME:vm-$id-disk-0
qm set $id --boot c --bootdisk scsi0
qm set $id --ide2 $STORAGE_NAME:cloudinit
qm set $id --serial0 socket --vga serial0
qm set $id --agent enabled=1

qm list| grep $id