#!/bin/sh
# setup IOT setting for LS1012A

cd /usr/
cp httpd.conf /etc/apache/
cp index.html /usr/share/htdocs/
apachectl restart

cd /usr/
tar xzvf node-red.tar.gz
node node-red/red.js