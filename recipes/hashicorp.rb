#
# Cookbook:: osl-repos
# Recipe:: hashicorp
#
# Copyright:: 2023-2025, Oregon State University
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

apt_repository 'hashicorp' do
  uri 'https://apt.releases.hashicorp.com'
  key 'https://apt.releases.hashicorp.com/gpg'
  components %w(main)
end if platform_family?('debian')

yum_repository 'hashicorp' do
  description 'Hashicorp'
  baseurl hashicorp_yum_baseurl
  gpgkey 'https://rpm.releases.hashicorp.com/gpg'
end if platform_family?('rhel')
