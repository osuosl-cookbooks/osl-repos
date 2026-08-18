# Cookbook:: osl-repos
# Spec:: elrepo
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

describe 'osl-repos::elrepo' do
  ALL_RHEL.each do |p|
    context "#{p[:platform]} #{p[:version]}" do
      cached(:chef_run) do
        # step_into to assert on the resources created inside
        ChefSpec::SoloRunner.new(p.dup.merge(step_into: [:osl_repos_elrepo])).converge(described_recipe)
      end

      it 'converges successfully' do
        expect { chef_run }.to_not raise_error
      end

      # gpgkey and description come from the yum-elrepo helpers
      gpgkey =
        if p[:version].to_i >= 10
          'https://www.elrepo.org/RPM-GPG-KEY-v2-elrepo.org'
        else
          'https://elrepo.org/RPM-GPG-KEY-elrepo.org https://www.elrepo.org/RPM-GPG-KEY-v2-elrepo.org'
        end
      description = "ELRepo.org Community Enterprise Linux Repository - el#{p[:version].to_i}"

      # One context per supported architecture
      %w(x86_64 ppc64le aarch64 s390x).each do |arch|
        context "arch #{arch}" do
          cached(:chef_run) do
            ChefSpec::SoloRunner.new(p.dup.merge(step_into: [:osl_repos_elrepo])) do |node|
              node.automatic['kernel']['machine'] = arch
            end.converge(described_recipe)
          end

          # elrepo is x86_64 only
          if arch == 'x86_64'
            it do
              expect(chef_run).to create_yum_repository('elrepo').with(
                mirrorlist: nil,
                exclude: nil,
                description: description,
                gpgkey: gpgkey,
                baseurl: 'https://ftp.osuosl.org/pub/elrepo/elrepo/el$releasever/$basearch/',
                enabled: true
              )
            end

          else
            it do
              expect(chef_run).to_not create_yum_repository('elrepo')
            end
          end
        end
      end

      # Unlike epel, turning elrepo off leaves the repo unmanaged
      context 'with elrepo false' do
        cached(:chef_run) do
          ChefSpec::SoloRunner.new(p.dup.merge(step_into: [:osl_repos_elrepo])).converge('osl-repos-test::elrepo_off')
        end

        it { expect(chef_run).to_not create_yum_repository('elrepo') }
      end

      context 'with exclude' do
        cached(:chef_run) do
          ChefSpec::SoloRunner.new(p.dup.merge(step_into: [:osl_repos_elrepo])).converge('osl-repos-test::elrepo_exclude')
        end

        it do
          expect(chef_run).to create_yum_repository('elrepo').with(
            baseurl: 'https://ftp.osuosl.org/pub/elrepo/elrepo/el$releasever/$basearch/',
            exclude: 'kmod-foo kmod-bar',
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
        ChefSpec::SoloRunner.new(p.dup.merge(step_into: [:osl_repos_elrepo])).converge(described_recipe)
      end

      it 'converges successfully' do
        expect { chef_run }.to_not raise_error
      end

      it { expect(chef_run).to_not create_yum_repository('elrepo') }
    end
  end
end
