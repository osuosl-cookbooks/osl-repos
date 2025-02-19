#
# Cookbook:: osl-repos
# Spec:: elevate
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

require_relative '../../spec_helper'

describe 'osl-repos::elevate' do
  ALL_RHEL.each do |p|
    context "#{p[:platform]} #{p[:version]}" do
      cached(:chef_run) do
        ChefSpec::SoloRunner.new(p).converge(described_recipe)
      end
      it 'converges successfully' do
        expect { chef_run }.to_not raise_error
      end
      it do
        expect(chef_run).to create_yum_repository('elevate').with(
          description: 'ELevate',
          url: "https://repo.almalinux.org/elevate/el#{p[:version].to_i}/$basearch/",
          gpgcheck: true,
          gpgkey: 'https://repo.almalinux.org/elevate/RPM-GPG-KEY-ELevate'
        )
      end
    end
  end
end
