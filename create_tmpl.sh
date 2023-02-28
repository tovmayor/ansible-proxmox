#!/bin/bash
#TMPL_NAME="ubuntu-2004-cloud"
TMPL_NAME="oracle-linux-8u7-cloud"
#IMG_NAME="ubuntu-20.04-server-cloudimg-amd64.img"
IMG_NAME="OL8U7_x86_64-kvm-b148.qcow"
STORAGE_NAME=local
MEM=8192
CORES=4
NETWORK="virtio,bridge=vmbr1"

if [ -z $1 ]
   then
	read -p "Enter id number for new template: " id
   else 
	id=$1
fi

if [ ! -f ./$IMG_NAME ]
   then 
        echo "Image with specified name does not exist"
        exit 1
fi

#   Converting qcow to img(raw), if present
if [ ${IMG_NAME#*.}="qcow" ]
   then 
        qemu-img convert -f qcow2 -O raw $IMG_NAME "${IMG_NAME%%.*}.img"
fi
IMG_NAME="${IMG_NAME%%.*}.img"

echo " Working with image $IMG_NAME"
qm create $id --name $TMPL_NAME --memory $MEM --cores $CORES --net0 $NETWORK
qm importdisk $id $IMG_NAME $STORAGE_NAME
qm set $id --scsihw virtio-scsi-pci --scsi0 $STORAGE_NAME:vm-$id-disk-0
qm set $id --boot c --bootdisk scsi0
qm set $id --ide2 $STORAGE_NAME:cloudinit
qm set $id --serial0 socket --vga serial0
qm set $id --agent enabled=1
qm template $id

qm list| grep $id
