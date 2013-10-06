#!/bin/bash
## \file    userdata.sh
#  \author  Scott Wales <scott.wales@unimelb.edu.au>
#  \brief   User data to boot a VM
#  
#  Copyright 2013 Scott Wales
#  
#  Licensed under the Apache License, Version 2.0 (the "License");
#  you may not use this file except in compliance with the License.
#  You may obtain a copy of the License at
#  
#      http://www.apache.org/licenses/LICENSE-2.0
#  
#  Unless required by applicable law or agreed to in writing, software
#  distributed under the License is distributed on an "AS IS" BASIS,
#  WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
#  See the License for the specific language governing permissions and
#  limitations under the License.
#  

set -x

openstackapi="http://169.254.169.254/2009-04-04"

# Set hostname
hostname=$(curl "$openstackapi/meta-data/public-hostname")
hostname $hostname

publicip4=$(curl "$openstackapi/meta-data/public-ipv4")
if [ -n "$publicip4" ]; then
    echo "$publicip4 $hostname"
fi

localip4=$(curl "$openstackapi/meta-data/local-ipv4")
if [ -n "$localip4" ]; then
    echo "$localip4 $hostname"
fi

# RPM to install puppet
rpm -i http://yum.puppetlabs.com/el/6/products/i386/puppetlabs-release-6-7.noarch.rpm

# Install puppet and git
yum install -y puppet git

rm -rf /etc/puppet
git clone https://github.com/ScottWales/base-vm /etc/puppet
git submodule update --init

puppet apply /etc/puppet/manifests/site.pp