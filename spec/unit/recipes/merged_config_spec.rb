# Cookbook:: osl-repos
# Spec:: merged_config
#
# Copyright:: 2020-2026, Oregon State University
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

describe 'osl-repos-test::merged_config' do
  ALL_RHEL.each do |p|
    context "#{p[:platform]} #{p[:version]}" do
      cached(:chef_run) do
        ChefSpec::SoloRunner.new(
          p.dup.merge(step_into: [:osl_repos_epel, :osl_repos_elrepo, :yum_epel_repository])
        ).converge(described_recipe)
      end

      it 'converges successfully' do
        expect { chef_run }.to_not raise_error
      end

      # Each resource keys its own bucket, so the excludes must not bleed across
      it { expect(chef_run).to create_yum_repository('epel').with(exclude: 'foo') }
      it { expect(chef_run).to create_yum_repository('elrepo').with(exclude: 'kmod-foo') }
    end
  end
end
