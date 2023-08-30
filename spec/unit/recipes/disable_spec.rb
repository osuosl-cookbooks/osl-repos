#
# Cookbook:: osl-repos-test
# Spec:: disable
#
# Copyright:: 2020-2023, Oregon State University
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
describe 'osl-repos-test::disable' do
  ALL_RHEL.each do |p|
    context "#{p[:platform]} #{p[:version]}" do
      cached(:chef_run) do
        # Here we step into each of our resources, this enables us to test the resources created within them
        ChefSpec::SoloRunner.new(p.dup.merge(step_into: ALL_RESOURCES)) do |node|
          # This sets the base architecture to 'x86_64'
          node.default['kernel']['machine'] = 'x86_64'
        end.converge(described_recipe)
      end

      # Check for convergence
      it 'converges successfully' do
        expect { chef_run }.to_not raise_error
      end

      # Test for the main configuration file ('/etc/yum.conf'cookstyle)
      it do
        expect(chef_run).to create_yum_globalconfig('/etc/yum.conf').with(
          installonly_limit: '2',
          installonlypkgs: 'kernel kernel-osuosl'
        )
      end

      case p[:version].to_i
      when 7

        # We need to test each supported architecture
        # This loop creates a context for each architecture and applies its tests.
        %w(x86_64 aarch64 s390x).each do |arch|
          context "arch #{arch}" do
            cached(:chef_run) do
              ChefSpec::SoloRunner.new(p.dup.merge(step_into: [:osl_repos_centos])) do |node|
                # Here we set the architecture to match our current iteration of the loop
                node.automatic['kernel']['machine'] = arch
              end.converge(described_recipe)
            end

            # The following will test for the correct settings being applied to each Centos 7 repository
            # ( Based on the default values for managed and enabled being set to true )

            case arch
            when 'aarch64', 's390x'

              # The base url of our repos is determined by the architecture
              # These architectures will all use the baseurl prefix 'https://centos-altarch.osuosl.org'

              # Test the base repository
              it do
                expect(chef_run).to create_yum_repository('base').with(
                  mirrorlist: nil,
                  baseurl: 'https://centos-altarch.osuosl.org/$releasever/os/$basearch/',
                  gpgkey: 'file:///etc/pki/rpm-gpg/RPM-GPG-KEY-CentOS-7 file:///etc/pki/rpm-gpg/RPM-GPG-KEY-CentOS-SIG-AltArch-7-$basearch',
                  enabled: true
                )
              end

              # Test the extras repository
              it do
                expect(chef_run).to create_yum_repository('extras').with(
                  mirrorlist: nil,
                  baseurl: 'https://centos-altarch.osuosl.org/$releasever/extras/$basearch/',
                  gpgkey: 'file:///etc/pki/rpm-gpg/RPM-GPG-KEY-CentOS-7 file:///etc/pki/rpm-gpg/RPM-GPG-KEY-CentOS-SIG-AltArch-7-$basearch',
                  enabled: true
                )
              end

              # Test the updates repository
              it do
                expect(chef_run).to create_yum_repository('updates').with(
                  mirrorlist: nil,
                  baseurl: 'https://centos-altarch.osuosl.org/$releasever/updates/$basearch/',
                  gpgkey: 'file:///etc/pki/rpm-gpg/RPM-GPG-KEY-CentOS-7 file:///etc/pki/rpm-gpg/RPM-GPG-KEY-CentOS-SIG-AltArch-7-$basearch',
                  enabled: false
                )
              end

            else

              # Test the base repository
              it do
                expect(chef_run).to create_yum_repository('base').with(
                  mirrorlist: nil,
                  baseurl: 'https://centos.osuosl.org/$releasever/os/$basearch/',
                  gpgkey: 'file:///etc/pki/rpm-gpg/RPM-GPG-KEY-CentOS-7',
                  enabled: true
                )
              end

              # Test the extras repository
              it do
                expect(chef_run).to create_yum_repository('extras').with(
                  mirrorlist: nil,
                  baseurl: 'https://centos.osuosl.org/$releasever/extras/$basearch/',
                  gpgkey: 'file:///etc/pki/rpm-gpg/RPM-GPG-KEY-CentOS-7',
                  enabled: true
                )
              end

              # Test the updates repository
              it do
                expect(chef_run).to create_yum_repository('updates').with(
                  mirrorlist: nil,
                  baseurl: 'https://centos.osuosl.org/$releasever/updates/$basearch/',
                  gpgkey: 'file:///etc/pki/rpm-gpg/RPM-GPG-KEY-CentOS-7',
                  enabled: false
                )
              end

            end
          end
        end

        # ppc64le can either be power8 or power9 architecture, we will test for both cases
        %w(power8 power9).each do |arch|
          context "arch #{arch}" do
            cached(:chef_run) do
              ChefSpec::SoloRunner.new(p.dup.merge(step_into: [:osl_repos_centos])) do |node|
                node.automatic['kernel']['machine'] = 'ppc64le'

                # Set cpu_model to either power8 or power9
                node.automatic['ibm_power']['cpu']['cpu_model'] = arch
              end.converge(described_recipe)
            end

            base_arch = arch == 'power9' ? 'power9' : '$basearch'

            # Test the base repository
            it do
              expect(chef_run).to create_yum_repository('base').with(
                mirrorlist: nil,
                baseurl: "https://centos-altarch.osuosl.org/$releasever/os/#{base_arch}/",
                gpgkey: 'file:///etc/pki/rpm-gpg/RPM-GPG-KEY-CentOS-7 file:///etc/pki/rpm-gpg/RPM-GPG-KEY-CentOS-SIG-AltArch-7-$basearch',
                enabled: true
              )
            end

            # Test the extras repository
            it do
              expect(chef_run).to create_yum_repository('extras').with(
                mirrorlist: nil,
                baseurl: "https://centos-altarch.osuosl.org/$releasever/extras/#{base_arch}/",
                gpgkey: 'file:///etc/pki/rpm-gpg/RPM-GPG-KEY-CentOS-7 file:///etc/pki/rpm-gpg/RPM-GPG-KEY-CentOS-SIG-AltArch-7-$basearch',
                enabled: true
              )
            end

            # Test the updates repository
            it do
              expect(chef_run).to create_yum_repository('updates').with(
                mirrorlist: nil,
                baseurl: "https://centos-altarch.osuosl.org/$releasever/updates/#{base_arch}/",
                gpgkey: 'file:///etc/pki/rpm-gpg/RPM-GPG-KEY-CentOS-7 file:///etc/pki/rpm-gpg/RPM-GPG-KEY-CentOS-SIG-AltArch-7-$basearch',
                enabled: false
              )
            end
          end
        end

      when 8
        url = 'almalinux.osuosl.org'

        # We need to test each supported architecture
        # This loop creates a context for each architecture and applies its tests.
        %w(x86_64 aarch64 s390x).each do |arch|
          context "arch #{arch}" do
            cached(:chef_run) do
              ChefSpec::SoloRunner.new(p.dup.merge(step_into: ALMA_RESOURCES)) do |node|
                node.automatic['kernel']['machine'] = arch
              end.converge(described_recipe)
            end

            # The following will test for the correct settings being applied to each Alma 8 repository
            # ( Based on the default values for managed and enabled being set to true )

            # Test the appstream repository
            it do
              expect(chef_run).to create_yum_repository('appstream').with(
                mirrorlist: nil,
                baseurl: "https://#{url}/$releasever/AppStream/$basearch/os/",
                enabled: true
              )
            end

            # Test the base repository
            it do
              expect(chef_run).to create_yum_repository('baseos').with(
                mirrorlist: nil,
                baseurl: "https://#{url}/$releasever/BaseOS/$basearch/os/",
                enabled: true
              )
            end

            # Test the extras repository
            it do
              expect(chef_run).to create_yum_repository('extras').with(
                mirrorlist: nil,
                baseurl: "https://#{url}/$releasever/extras/$basearch/os/",
                enabled: true
              )
            end

            # Test the highavailability repository
            it do
              expect(chef_run).to create_yum_repository('highavailability').with(
                mirrorlist: nil,
                baseurl: "https://#{url}/$releasever/HighAvailability/$basearch/os/",
                enabled: false
              )
            end

            # Test the powertools repository
            it do
              expect(chef_run).to create_yum_repository('powertools').with(
                mirrorlist: nil,
                baseurl: "https://#{url}/$releasever/PowerTools/$basearch/os/",
                enabled: false
              )
            end
          end
        end

        # ppc64le can either be power8 or power9 architecture, we will test for both cases
        %w(power8 power9).each do |arch|
          context "arch #{arch}" do
            cached(:chef_run) do
              ChefSpec::SoloRunner.new(p.dup.merge(step_into: ALMA_RESOURCES)) do |node|
                node.automatic['kernel']['machine'] = 'ppc64le'

                # Set cpu_model to either power8 or power9
                node.automatic['ibm_power']['cpu']['cpu_model'] = arch
              end.converge(described_recipe)
            end

            # Test the appstream repository
            it do
              expect(chef_run).to create_yum_repository('appstream').with(
                mirrorlist: nil,
                baseurl: "https://#{url}/$releasever/AppStream/$basearch/os/",
                enabled: true
              )
            end

            # Test the base repository
            it do
              expect(chef_run).to create_yum_repository('baseos').with(
                mirrorlist: nil,
                baseurl: "https://#{url}/$releasever/BaseOS/$basearch/os/",
                enabled: true
              )
            end

            # Test the extras repository
            it do
              expect(chef_run).to create_yum_repository('extras').with(
                mirrorlist: nil,
                baseurl: "https://#{url}/$releasever/extras/$basearch/os/",
                enabled: true
              )
            end

            # Test the highavailability repository
            it do
              expect(chef_run).to create_yum_repository('highavailability').with(
                mirrorlist: nil,
                baseurl: "https://#{url}/$releasever/HighAvailability/$basearch/os/",
                enabled: false
              )
            end

            # Test the powertools repository
            it do
              expect(chef_run).to create_yum_repository('powertools').with(
                mirrorlist: nil,
                baseurl: "https://#{url}/$releasever/PowerTools/$basearch/os/",
                enabled: false
              )
            end
          end
        end
      end
    end
  end
end
