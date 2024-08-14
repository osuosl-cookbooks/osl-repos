#
# Cookbook:: osl-repos
# Recipe:: debian
#
# Copyright:: 2024, Oregon State University
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

apt_update 'update' do
  action :nothing
end

template '/etc/apt/sources.list' do
  source 'debian.sources.list.erb'
  notifies :update, 'apt_update[update]', :immediately
end

# TODO: Needed since trixie is still under testing
file '/etc/apt/apt.conf.d/99osuosl' do
  content 'APT::Default-Release "trixie";'
end if node['lsb']['codename'] == 'trixie'

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
