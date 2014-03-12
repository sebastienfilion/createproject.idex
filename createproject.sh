#!/bin/bash

if [ $# -eq 0 ]
  then
    echo $(tput setaf 1)'No arguments supplied'$(tput setaf 7);
    exit 1;
fi


{
    echo $(tput setaf 3)'Cloning git'$(tput setaf 7);
    git clone https://github.com/sebastienfilion/project.idex `pwd`/$2;
} & wait


{
    echo $(tput setaf 3)'Cleaning up'$(tput setaf 7);
    rm -rf `pwd`/$2/.git;
    chmod -R 777 `pwd`/$2;
} & wait

echo $(tput setaf 3)'Creating virtual host'$(tput setaf 7);

{
    echo '\n# Generated\n127.0.0.1 ' $1 >> /etc/hosts;
    
    echo '\n# Generated '$1'
<VirtualHost *:80>
    DocumentRoot "'`pwd`/$2'"
    ServerName '$1'
    ErrorLog "/private/var/log/apache2/'$1'-error_log"
    CustomLog "/private/var/log/apache2/'$1'-access_log" common
</VirtualHost>' >> /etc/apache2/extra/httpd-vhosts.conf;

    apachectl graceful;
} & wait

echo $(tput setaf 3)'All done!'$(tput setaf 7);
