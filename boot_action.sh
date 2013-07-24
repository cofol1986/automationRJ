#!/bin/bash
lockfile="/lock.file"
ip_chefsvr="172.18.4.86"
ip_postfiles="172.18.4.86"
ntp_svr=$ip_chefsvr
logfile="/root/initial-log"

{
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
    echo "$ip_chefsvr chefsvr" >> /etc/hosts
    #ntp set
    service ntp stop
    ntp $ntp_svr
    wget http://$ip_postfiles/post/chef_10.26.0-1.ubuntu.11.04_amd64.deb
    dpkg -i chef_10.26.0-1.ubuntu.11.04_amd64.deb
    mkdir -p /etc/chef/
    cd /etc/chef; wget http://$ip_postfiles/post/validation.pem; wget http://$ip_postfiles/post/client.rb
    chef-client
    cd /root


    rm "$lockfile"
#else
    #echo "lock file doesn't exit"
fi
} &> $logfile



exit 0
