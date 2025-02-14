#
# Cookbook:: osl-repos
# Spec:: oslrepo
#
# Copyright:: 2022-2025, Oregon State University
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

require_relative '../../spec_helper'

describe 'osl-repos::oslrepo' do
  ALL_PLATFORMS.each do |p|
    context "#{p[:platform]} #{p[:version]}" do
      cached(:chef_run) do
        ChefSpec::SoloRunner.new(p).converge(described_recipe)
      end
      it 'converges successfully' do
        expect { chef_run }.to_not raise_error
      end
      case p
      when *ALL_RHEL
        it do
          is_expected.to create_yum_repository('osl').with(
            repositoryid: 'osl',
            description: 'OSL repo $releasever - $basearch',
            url: "http://packages.osuosl.org/repositories/#{p[:platform]}-$releasever/osl/$basearch",
            gpgcheck: false
          )
        end
      when *ALL_DEBIAN
        it do
          is_expected.to add_apt_repository('osl').with(
            uri: 'http://packages.osuosl.org/repositories/apt-repo-osl/',
            components: %w(main),
            key: %w(http://packages.osuosl.org/repositories/apt-repo-osl/repo.gpg),
            arch: 'amd64'
          )
        end
      end
    end
  end
end
