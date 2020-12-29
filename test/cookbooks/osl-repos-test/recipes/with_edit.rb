#
# Cookbook:: osl-repos
# Recipe:: with_edit
#
# Copyright:: 2020, Oregon State University
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

# This is an example of using the 'edit resource' function to modify the already included and enabled repos
include_recipe 'osl-repos::centos'

edit_resource(:osl_repos_centos, 'default') do
  appstream false
  base false
  extras false
  powertools true
  powertools_enabled false
  updates true
end
