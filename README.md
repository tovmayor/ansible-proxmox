# ansible-proxmox
Creating VM`s on PVE host with ansible

Create vm template with create_tmpl.sh shell command file. Edit variables section with correct values and run file with template's id as argument.

Fill ansible inventory file px_inv with your PVE host name and ip-address.

Edit variable section of proxmox_multi.yml playbook file.
Use ansible-playbook to run playbook:
>ansible-playbook proxmox_multi.yml -i px_inv
