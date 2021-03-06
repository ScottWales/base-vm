## \file    modules/tomcat/manifests/init.pp
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

class tomcat {
  package {'tomcat6':
    ensure => present,
  } ->
  service {'tomcat6':
    ensure => running,
  }

  $catalina_base = '/usr/share/tomcat6'
  $catalina_home = '/usr/share/tomcat6'
  $jasper_home = '/usr/share/tomcat6'

}
