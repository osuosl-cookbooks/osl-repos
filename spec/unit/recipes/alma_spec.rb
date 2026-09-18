#
# Cookbook:: osl-repos
# Spec:: default
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

describe 'osl-repos::alma' do
  [ALMA_8, ALMA_9, ALMA_10].each do |p|
    context "#{p[:platform]} #{p[:version]}" do
      cached(:chef_run) do
        # step_into to assert on the resources created inside
        ChefSpec::SoloRunner.new(p.dup.merge(step_into: ALL_RESOURCES)) do |node|
          node.default['kernel']['machine'] = 'x86_64'
        end.converge(described_recipe)
      end

      it 'converges successfully' do
        expect { chef_run }.to_not raise_error
      end

      it do
        expect(chef_run).to create_yum_globalconfig('/etc/yum.conf').with(
          cachedir: '/var/cache/dnf',
          installonly_limit: '2',
          installonlypkgs: 'kernel kernel-osuosl',
          clean_requirements_on_remove: true
        )
      end

      rel = '$releasever'

      # One context per supported architecture
      %w(x86_64 ppc64le aarch64 s390x).each do |arch|
        context "#arch #{arch}" do
          cached(:chef_run) do
            ChefSpec::SoloRunner.new(p.dup.merge(step_into: ALMA_RESOURCES)) do |node|
              node.automatic['kernel']['machine'] = arch
              node.automatic['os_release']['name'] = 'almalinux'
            end.converge(described_recipe)
          end

          # Defaults have managed and enabled both true
          it do
            expect(chef_run).to create_yum_repository('appstream').with(
              mirrorlist: nil,
              baseurl: "https://almalinux.osuosl.org/#{rel}/AppStream/$basearch/os/",
              enabled: true
            )
          end

          it do
            expect(chef_run).to create_yum_repository('baseos').with(
              mirrorlist: nil,
              baseurl: "https://almalinux.osuosl.org/#{rel}/BaseOS/$basearch/os/",
              enabled: true
            )
          end

          it do
            expect(chef_run).to create_yum_repository('extras').with(
              mirrorlist: nil,
              baseurl: "https://almalinux.osuosl.org/#{rel}/extras/$basearch/os/",
              enabled: true
            )
          end

          it do
            expect(chef_run).to create_yum_repository('highavailability').with(
              mirrorlist: nil,
              baseurl: "https://almalinux.osuosl.org/#{rel}/HighAvailability/$basearch/os/",
              enabled: false
            )
          end

          it do
            expect(chef_run).to create_yum_repository('synergy').with(
              mirrorlist: nil,
              baseurl: "https://almalinux.osuosl.org/#{rel}/synergy/$basearch/os/",
              enabled: false
            )
          end

          # baseurl comes from the upstream yum-almalinux default
          it do
            expect(chef_run).to create_yum_repository('testing').with(
              baseurl: "https://vault.almalinux.org/#{p[:version].to_i}/testing/$basearch/os/",
              enabled: false
            )
          end

          # Only declared when nvidia is true, it installs a release package
          it { expect(chef_run).not_to create_yum_repository('nvidia') }

          power_tools = p[:version].to_i >= 9 ? 'CRB' : 'PowerTools'
          it do
            expect(chef_run).to create_yum_repository(power_tools.downcase).with(
              mirrorlist: nil,
              baseurl: "https://almalinux.osuosl.org/#{rel}/#{power_tools}/$basearch/os/",
              enabled: true
            )
          end
        end
      end
    end
  end
end
