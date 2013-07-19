#!/bin/bash
lockfile="/lock.file"
ip_chefsvr="192.168.1.1"
ip_postfiles="192.168.1.1"
ntp_svr=$ip_chefsvr

if [ -f "$lockfile" ]; then
    #clear http_proxy for apt
    echo > /etc/apt/apt.conf
    apt-get update
    apt-get -y install ruby

    #install ceph
    wget -q -O- http://172.18.11.80/ceph.key | apt-key add -
    echo "deb [arch=amd64] http://172.18.11.80/debian-cuttlefish/ precise main" > /etc/apt/sources.list.d/ceph.list
    apt-get update && apt-get install -y --force-yes ceph ceph-deploy ceph-fuse
    apt-get install -y fio

    #install chef-client
    #setup config files
    echo "$ip_chefsvr chefsvr" >> /etc/hosts
    mkdir -p /etc/chef/
    cd /etc/chef
    wget http://$ip_postfiles/post/validation.pem; wget http://$ip_postfiles/post/client.rb
    cat <<EOH > client.json
    {
	 "run_list": [ "role[base_role]" ]
    }
EOH

    #ntp set
    service ntp stop
    ntpdate $ntp_svr
    #installation
    wget http://$ip_postfiles/post/chef_10.26.0-1.ubuntu.11.04_amd64.deb
    dpkg -i chef_10.26.0-1.ubuntu.11.04_amd64.deb
    #chef configuration
    chef-client -d -i 60 -s 120 -j client.json
    cd /


    rm "$lockfile"
#else
    #echo "lock file doesn't exit"
fi




exit 0
