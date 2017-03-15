#!/bin/bash

# This is BASH script for autoconfigure of Rsyslog Server
# You must run this script as root.
#Created by Lukasz Sulkowski for CarbonBlack, but absolutely unsupported so you are on your own here.
#This script is proven to work on RHEL/CENTOS 5,6
yum install rsyslog -y
yum install rsyslog-gnutls -y
yum install gnutls-utils -y
certtool --generate-privkey --outfile /etc/pki/rsyslog/ca-key.pem
certtool --generate-self-signed --load-privkey /etc/pki/rsyslog/ca-key.pem --outfile /etc/pki/rsyslog/ca.pem
certtool --generate-privkey --outfile /etc/pki/rsyslog/rslserver-key.pem --bits 2048
certtool --generate-request --load-privkey /etc/pki/rsyslog/rslserver-key.pem --outfile /etc/pki/rsyslog/request.pem
certtool --generate-certificate --load-request /etc/pki/rsyslog/request.pem --outfile /etc/pki/rsyslog/rslserver-cert.pem --load-ca-certificate /etc/pki/rsyslog/ca.pem --load-ca-privkey /etc/pki/rsyslog/ca-key.pem
chmod 0600 /etc/pki/rsyslog/*
iptables -A INPUT -m state --state NEW -m tcp -p tcp --dport 514 -j ACCEPT
/sbin/service iptables save
service iptables restart
yes | cp -rf /home/rsyslog.conf /etc/rsyslog.conf
service rsyslog restart
