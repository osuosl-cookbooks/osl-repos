# Cookbook:: osl-repos
# Spec:: epel
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

describe 'osl-repos::epel' do
  ALL_RHEL.each do |p|
    context "#{p[:platform]} #{p[:version]}" do
      cached(:chef_run) do
        # step_into to assert on the resources created inside
        ChefSpec::SoloRunner.new(p.dup.merge(step_into: [:osl_repos_epel, :yum_epel_repository])).converge(described_recipe)
      end

      it 'converges successfully' do
        expect { chef_run }.to_not raise_error
      end

      baseurl =
        if p == ALMA_10
          'https://epel.osuosl.org/$releasever${releasever_minor:+z}/Everything/$basearch/'
        else
          'https://epel.osuosl.org/$releasever/Everything/$basearch/'
        end
      gpgkey = "https://epel.osuosl.org/RPM-GPG-KEY-EPEL-#{p[:version].to_i}"

      it do
        expect(chef_run).to create_yum_repository('epel').with(
          mirrorlist: nil,
          exclude: nil,
          baseurl: baseurl,
          gpgkey: gpgkey,
          enabled: true
        )
      end

      # Turning epel off still writes the repo, disabled
      context 'with epel false' do
        cached(:chef_run) do
          ChefSpec::SoloRunner.new(p.dup.merge(step_into: [:osl_repos_epel, :yum_epel_repository]))
                              .converge('osl-repos-test::epel_off')
        end

        it do
          expect(chef_run).to create_yum_repository('epel').with(
            baseurl: baseurl,
            enabled: false
          )
        end
      end

      # epel_enabled leaves the repo managed but disabled
      context 'with epel_enabled false' do
        cached(:chef_run) do
          ChefSpec::SoloRunner.new(p.dup.merge(step_into: [:osl_repos_epel, :yum_epel_repository]))
                              .converge('osl-repos-test::epel_not_enabled')
        end

        it do
          expect(chef_run).to create_yum_repository('epel').with(
            baseurl: baseurl,
            enabled: false
          )
        end
      end

      # exclude is passed through yum_epel_repository's options property
      context 'with exclude' do
        cached(:chef_run) do
          ChefSpec::SoloRunner.new(p.dup.merge(step_into: [:osl_repos_epel, :yum_epel_repository]))
                              .converge('osl-repos-test::epel_exclude')
        end

        it do
          expect(chef_run).to create_yum_repository('epel').with(
            baseurl: baseurl,
            exclude: 'foo bar',
            enabled: true
          )
        end
      end
    end
  end

  # No-op off rhel
  ALL_DEBIAN.each do |p|
    context "#{p[:platform]} #{p[:version]}" do
      cached(:chef_run) do
        ChefSpec::SoloRunner.new(p.dup.merge(step_into: [:osl_repos_epel, :yum_epel_repository])).converge(described_recipe)
      end

      it 'converges successfully' do
        expect { chef_run }.to_not raise_error
      end

      it { expect(chef_run).to_not create_yum_repository('epel') }
    end
  end
end
