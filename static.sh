#!/bin/bash
cat > /etc/apt/sources.list <<EOF

deb [arch=amd64] http://172.18.4.81/precise/ precise main restricted universe multiverse
deb [arch=amd64] http://172.18.4.81/precise/ precise-updates main restricted universe multiverse

EOF

touch lock.file



