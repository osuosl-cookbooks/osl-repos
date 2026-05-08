#
# Cookbook:: osl-repos
# Recipe:: debian
#
# Copyright:: 2024-2026, Oregon State University
#
# Licensed under the Apache License, Version 2.0 (the "License");
# you may not use this file except in compliance with the License.
# You may obtain a copy of the License at
#
#     http://www.apache.org/licenses/LICENSE-2.0
#
# Unless required by applicable law or agreed to in writing, software
# distributed under the License is distributed on an "AS IS" BASIS,
# WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
# See the License for the specific language governing permissions and
# limitations under the License.

# The Debian installer drops a deb822 sources file at /etc/apt/sources.list.d/debian.sources
# which would conflict with the legacy /etc/apt/sources.list we manage below.
execute 'remove deb822 sources file' do
  command 'rm -f /etc/apt/sources.list.d/*.sources'
  not_if { Dir.glob('/etc/apt/sources.list.d/*.sources').empty? }
end

apt_update 'update' do
  action :nothing
end

template '/etc/apt/sources.list' do
  source 'debian.sources.list.erb'
  notifies :update, 'apt_update[update]', :immediately
end

package %w(unattended-upgrades apt-listchanges)

cookbook_file '/etc/apt/apt.conf.d/50unattended-upgrades' do
  source 'debian-50unattended-upgrades'
  notifies :restart, 'service[unattended-upgrades.service]'
end

service 'unattended-upgrades.service' do
  action [:enable, :start]
end

service 'apt-daily-upgrade.timer' do
  action [:enable, :start]
end
