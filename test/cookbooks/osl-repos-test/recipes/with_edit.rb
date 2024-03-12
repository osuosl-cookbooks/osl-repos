#
# Cookbook:: osl-repos
# Recipe:: with_edit
#
# Copyright:: 2020-2024, Oregon State University
#
# Licensed under the Apache License, Version 2.0 (the "License");
# you may not use this file except in compliance with the License.
# You may obtain a copy of the License at
#
#     https://www.apache.org/licenses/LICENSE-2.0
#
# Unless required by applicable law or agreed to in writing, software
# distributed under the License is distributed on an "AS IS" BASIS,
# WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
# See the License for the specific language governing permissions and
# limitations under the License.

# This is an example of using the 'edit resource' function to modify the already included and enabled repos
platform = platform?('centos') ? 'centos' : 'alma'

include_recipe "osl-repos::#{platform}"

edit_resource('osl_repos_centos'.to_sym, 'default') do
  extras false
  updates false
  exclude %w(foo bar)
end if platform == 'centos'

edit_resource('osl_repos_alma'.to_sym, 'default') do
  appstream false if platform == 'alma'
  extras false
  powertools false if platform == 'alma'
  exclude %w(foo bar)
end if platform == 'alma'
