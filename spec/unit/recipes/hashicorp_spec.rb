#
# Cookbook:: osl-repos
# Spec:: hashicorp
#
# Copyright:: 2023, Oregon State University
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

describe 'osl-repos::hashicorp' do
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
          expect(chef_run).to create_yum_repository('hashicorp').with(
            baseurl: 'https://rpm.releases.hashicorp.com/RHEL/$releasever/$basearch/stable',
            gpgkey: 'https://rpm.releases.hashicorp.com/gpg'
          )
        end
      when *ALL_DEBIAN
        it do
          expect(chef_run).to add_apt_repository('hashicorp').with(
            uri: 'https://apt.releases.hashicorp.com',
            key: %w(https://apt.releases.hashicorp.com/gpg),
            components: %w(main)
          )
        end
      end
    end
  end
end
