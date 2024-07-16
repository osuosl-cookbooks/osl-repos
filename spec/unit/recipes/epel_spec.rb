# Cookbook:: osl-repos
# Spec:: epel
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

require_relative '../../spec_helper'

# Begin Spec Tests
describe 'osl-repos::epel' do
  ALL_RHEL.each do |p|
    context "#{p[:platform]} #{p[:version]}" do
      cached(:chef_run) do
        # Here we step into our :osl_repos_epel resource, this enables us to test the resources created within it
        ChefSpec::SoloRunner.new(p.dup.merge(step_into: [:osl_repos_epel])).converge(described_recipe)
      end

      # Check for convergence
      it 'converges successfully' do
        expect { chef_run }.to_not raise_error
      end

      # Test the epel repository
      it do
        expect(chef_run).to create_yum_repository('epel').with(
          mirrorlist: nil,
          exclude: nil,
          baseurl: 'https://epel.osuosl.org/$releasever/Everything/$basearch/',
          gpgkey: "https://epel.osuosl.org/RPM-GPG-KEY-EPEL-#{p[:version].to_i}",
          enabled: true
        )
      end
    end
  end
end
