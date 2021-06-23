#!/usr/bin/env bash
###
 # @Author: icheontao
 # @Email: me@taolichuan.com
 # @Date: 2021-06-23 13:25:44
 # @LastEditTime: 2021-06-23 14:09:49
 # @Github: https://github.com/icheontao
### 


disk_name=$(df -h|grep -P '/dev/sd[a-z]' -o|sort|tail -1|awk '{print $1}')

for i in $(fdisk -l|grep /dev/sd|sort|awk '{print $2}'|awk -F":" '{print $1}');do
    if [ $i \> $disk_name ];then
        num=$(printf "%d" "'${i: -1}")
        mount_directory=$(printf "data%02d" $(($num-96)))
        # parted
        mkdir "/$mount_directory"
        parted -s $i 'mklabel gpt'
        parted -s -a optimal $i 'mkpart primary 0% 100%'
        echo y | mkfs -t ext4 $i
        echo "$i /$mount_directory ext4 defaults 0 0" >> /etc/fstab
    fi
done

mount -a
