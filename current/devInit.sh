#!/usr/bin/env bash

# set default values
crxHost="localhost"
crxPort="4502"
crxUser="admin"
crxPassword="admin"

#trigger interactive
if [ "$1" == "-i" ]; then
    # prompt parameters
    read -p "Enter the host name [$crxHost]: " host
    crxHost=${host:-$crxHost}
    read -p "Enter the port [$crxPort]: " port
    crxPort=${port:-$crxPort}
    read -p "Enter the username [$crxUser]: " user
    crxUser=${user:-$crxUser}
    read -p "Enter the password [$crxPassword]: " pw
    crxPassword=${pw:-$crxPassword}
fi

# log input
echo "host: $host | port: $port"

# Maven Install
mvn -Pauto-deploy-all clean install -Dcq.host=${crxHost} -Dcq.port=${crxPort} -Dcq.user=${crxUser} -Dcq.password=${crxPassword} -U;

# Go to 'content' module root
cd brightcove-view/src/main/content/jcr_root/;

# Remove .vlt files
find . -name '.vlt'  -exec rm {} \;

# VLT checkout
vlt --credentials ${crxUser}:${crxPassword} co --force http://${crxHost}:${crxPort}/crx

# Go Back.
cd -;