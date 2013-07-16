#!/bin/bash
lockfile="/lock.file"


if [ -f "$lockfile" ]; then
    #clear http_proxy for apt
    echo > /etc/apt/apt.conf
    apt-get update
    apt-get -y install ruby
   
    #install ceph 
    wget -q -O- http://172.18.11.80/ceph.key | apt-key add -
    echo "deb [arch=amd64] http://172.18.11.80/debian-cuttlefish/ precise main" > /etc/apt/sources.list.d/ceph.list
    apt-get update && apt-get install -y ceph ceph-deploy ceph-fuse
    apt-get install -y fio

    #install chef-client
    echo "172.16.4.86 chefsvr" >> /etc/hosts 
    wget http://172.18.4.86/post/chef_10.26.0-1.ubuntu.11.04_amd64.deb
    dpkg -i chef_10.26.0-1.ubuntu.11.04_amd64.deb
    mkdir -p /etc/chef/
    wget http://172.18.4.86/chef_10.26.0-1.ubuntu.11.04_amd64.deb
    cd /etc/chef; wget http://172.18.4.86/post/validation.pem; wget http://172.18.4.86/post/client.rb
    chef-client
    cd /root


    rm "$lockfile"
#else
    #echo "lock file doesn't exit"
fi




exit 0
