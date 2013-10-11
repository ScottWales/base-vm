## \file    modules/nagios/manifests/init.pp
#  \author  Scott Wales <scott.wales@unimelb.edu.au>
#  \brief
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

# Setup a Nagios server
class nagios (
  $vhost_name = '*',
  $port     = '80'
) {
  require epel
  include apache::mod::mime
  include apache::mod::dir
  include apache::mod::php
  include apache::mod::cgi

  package {'nagios':
    # Apache will delete the config files, install nagios first so the build is
    # stable
    before => Class['apache'],
  } ->
  service {'nagios':
    ensure => running,
  }

  file {'/var/www/.htauth_nagios':
    owner  => 'apache',
    source => 'puppet:///modules/nagios/htaccess',
  }

  apache::vhost {'nagios':
    vhost_name       => $vhost_name,
    port             => $port,
    docroot          => '/var/www',
    aliases          => [
      {alias         => '/nagios',
      path           => '/usr/share/nagios/html'}
    ],
    scriptalias      => '/usr/lib64/nagios/cgi-bin',
    redirect_source  => '/nagios/cgi-bin',
    redirect_dest    => '/cgi-bin',
    directories      => [

      {path          => '/usr/share/nagios/html',
      auth_type      => 'basic',
      auth_user_file => '/var/www/.htauth_nagios',
      auth_require   => 'valid-user',},

      {path          => '/usr/lib64/nagios/cgi-bin',
      auth_type      => 'basic',
      auth_user_file => '/var/www/.htauth_nagios',
      auth_require   => 'valid-user',},
    ],
  }
}
