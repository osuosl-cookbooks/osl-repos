#
# Cookbook:: osl-repos
# Spec:: default
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

require_relative '../../spec_helper'

describe 'osl-repos::default' do
  ALL_PLATFORMS.each do |p|
    context "#{p[:platform]} #{p[:version]}" do
      cached(:chef_run) do
        ChefSpec::SoloRunner.new(p.dup.merge(step_into: [:osl_repos_centos])) do |node|
          node.default['kernel']['machine'] = 'x86_64'
        end.converge(described_recipe)
      end

      it 'converges successfully' do
        expect { chef_run }.to_not raise_error
      end

      case p[:version].to_i
      when 7
        %w(x86_64 i386 aarch64 ppc64 ppc64le s390x).each do |arch|
          context "arch #{arch}" do
            cached(:chef_run) do
              ChefSpec::SoloRunner.new(p.dup.merge(step_into: [:osl_repos_centos])) do |node|
                node.automatic['kernel']['machine'] = arch
                if arch =~ /(ppc64|ppc64le)/
                  node.automatic['ibm_power']['cpu']['cpu_model'] = 'power9'
                end
              end.converge(described_recipe)
            end

            case arch
            when 'aarch64', 'ppc64', 'ppc64le', 's390x'
              case arch
              when 'ppc64', 'ppc64le'
                it do
                  expect(chef_run).to create_yum_repository('base').with(
                    mirrorlist: nil,
                    baseurl: 'http://centos-altarch.osuosl.org/$releasever/os/power9/',
                    gpgkey: "#{if arch == 'x86_64'
                                'file:///etc/pki/rpm-gpg/RPM-GPG-KEY-CentOS-7'
                              else
                                'file:///etc/pki/rpm-gpg/RPM-GPG-KEY-CentOS-7 ' \
                                'file:///etc/pki/rpm-gpg/RPM-GPG-KEY-CentOS-SIG-AltArch-7-$basearch'
                              end}",
                    enabled: true
                  )
                end

                it do
                  expect(chef_run).to create_yum_repository('updates').with(
                    mirrorlist: nil,
                    baseurl: 'http://centos-altarch.osuosl.org/$releasever/updates/power9/',
                    gpgkey: "#{if arch == 'x86_64'
                                'file:///etc/pki/rpm-gpg/RPM-GPG-KEY-CentOS-7'
                              else
                                'file:///etc/pki/rpm-gpg/RPM-GPG-KEY-CentOS-7 ' \
                                'file:///etc/pki/rpm-gpg/RPM-GPG-KEY-CentOS-SIG-AltArch-7-$basearch'
                              end}",
                    enabled: true
                  )
                end

                it do
                  expect(chef_run).to create_yum_repository('extras').with(
                    mirrorlist: nil,
                    baseurl: 'http://centos-altarch.osuosl.org/$releasever/extras/power9/',
                    gpgkey: "#{if arch == 'x86_64'
                                'file:///etc/pki/rpm-gpg/RPM-GPG-KEY-CentOS-7'
                              else
                                'file:///etc/pki/rpm-gpg/RPM-GPG-KEY-CentOS-7 ' \
                                'file:///etc/pki/rpm-gpg/RPM-GPG-KEY-CentOS-SIG-AltArch-7-$basearch'
                              end}",
                    enabled: true
                  )
                end

              when 'aarch64', 's390x'
                it do
                  expect(chef_run).to create_yum_repository('base').with(
                    mirrorlist: nil,
                    baseurl: 'http://centos-altarch.osuosl.org/$releasever/os/$basearch/',
                    gpgkey: "#{if arch == 'x86_64'
                                'file:///etc/pki/rpm-gpg/RPM-GPG-KEY-CentOS-7'
                              else
                                'file:///etc/pki/rpm-gpg/RPM-GPG-KEY-CentOS-7 ' \
                                'file:///etc/pki/rpm-gpg/RPM-GPG-KEY-CentOS-SIG-AltArch-7-$basearch'
                              end}",
                    enabled: true
                  )
                end

                it do
                  expect(chef_run).to create_yum_repository('updates').with(
                    mirrorlist: nil,
                    baseurl: 'http://centos-altarch.osuosl.org/$releasever/updates/$basearch/',
                    gpgkey: "#{if arch == 'x86_64'
                                'file:///etc/pki/rpm-gpg/RPM-GPG-KEY-CentOS-7'
                              else
                                'file:///etc/pki/rpm-gpg/RPM-GPG-KEY-CentOS-7 ' \
                                'file:///etc/pki/rpm-gpg/RPM-GPG-KEY-CentOS-SIG-AltArch-7-$basearch'
                              end}",
                    enabled: true
                  )
                end

                it do
                  expect(chef_run).to create_yum_repository('extras').with(
                    mirrorlist: nil,
                    baseurl: 'http://centos-altarch.osuosl.org/$releasever/extras/$basearch/',
                    gpgkey: "#{if arch == 'x86_64'
                                'file:///etc/pki/rpm-gpg/RPM-GPG-KEY-CentOS-7'
                              else
                                'file:///etc/pki/rpm-gpg/RPM-GPG-KEY-CentOS-7 ' \
                                'file:///etc/pki/rpm-gpg/RPM-GPG-KEY-CentOS-SIG-AltArch-7-$basearch'
                              end}",
                    enabled: true
                  )
                end
              end
            else
              it do
                expect(chef_run).to create_yum_repository('base').with(
                  mirrorlist: nil,
                  baseurl: 'http://centos.osuosl.org/$releasever/os/$basearch/',
                  gpgkey: "#{if arch == 'x86_64'
                              'file:///etc/pki/rpm-gpg/RPM-GPG-KEY-CentOS-7'
                            else
                              'file:///etc/pki/rpm-gpg/RPM-GPG-KEY-CentOS-7 ' \
                              'file:///etc/pki/rpm-gpg/RPM-GPG-KEY-CentOS-SIG-AltArch-7-$basearch'
                            end}",
                  enabled: true
                )
              end

              it do
                expect(chef_run).to create_yum_repository('updates').with(
                  mirrorlist: nil,
                  baseurl: 'http://centos.osuosl.org/$releasever/updates/$basearch/',
                  gpgkey: "#{if arch == 'x86_64'
                              'file:///etc/pki/rpm-gpg/RPM-GPG-KEY-CentOS-7'
                            else
                              'file:///etc/pki/rpm-gpg/RPM-GPG-KEY-CentOS-7 ' \
                              'file:///etc/pki/rpm-gpg/RPM-GPG-KEY-CentOS-SIG-AltArch-7-$basearch'
                            end}",
                  enabled: true
                )
              end

              it do
                expect(chef_run).to create_yum_repository('extras').with(
                  mirrorlist: nil,
                  baseurl: 'http://centos.osuosl.org/$releasever/extras/$basearch/',
                  gpgkey: "#{if arch == 'x86_64'
                              'file:///etc/pki/rpm-gpg/RPM-GPG-KEY-CentOS-7'
                            else
                              'file:///etc/pki/rpm-gpg/RPM-GPG-KEY-CentOS-7 ' \
                              'file:///etc/pki/rpm-gpg/RPM-GPG-KEY-CentOS-SIG-AltArch-7-$basearch'
                            end}",
                  enabled: true
                )
              end
            end

            it do
              expect(chef_run).to create_yum_repository('epel').with(
                mirrorlist: nil,
                baseurl: 'http://epel.osuosl.org/7/$basearch',
                gpgkey: 'http://epel.osuosl.org/RPM-GPG-KEY-EPEL-7',
                enabled: true
              )
            end
          end
        end
      when 8
        %w(x86_64 i386 aarch64 ppc64 ppc64le s390x).each do |arch|
          context "arch #{arch}" do
            cached(:chef_run) do
              ChefSpec::SoloRunner.new(p.dup.merge(step_into: [:osl_repos_centos])) do |node|
                node.automatic['kernel']['machine'] = arch
                if arch =~ /(ppc64|ppc64le)/
                  node.automatic['ibm_power']['cpu']['cpu_model'] = 'power9'
                end
              end.converge(described_recipe)
            end

            case arch
            when 'ppc64', 'ppc64le'
              it do
                expect(chef_run).to create_yum_repository('base').with(
                  mirrorlist: nil,
                  baseurl: 'http://centos.osuosl.org/$releasever/BaseOS/power9/os',
                  enabled: true
                )
              end

              it do
                expect(chef_run).to create_yum_repository('appstream').with(
                  mirrorlist: nil,
                  baseurl: 'http://centos.osuosl.org/$releasever/AppStream/power9/os',
                  enabled: true
                )
              end

              it do
                expect(chef_run).to create_yum_repository('extras').with(
                  mirrorlist: nil,
                  baseurl: 'http://centos.osuosl.org/$releasever/extras/power9/os',
                  enabled: true
                )
              end

              it do
                expect(chef_run).to create_yum_repository('powertools').with(
                  mirrorlist: nil,
                  baseurl: 'http://centos.osuosl.org/$releasever/PowerTools/power9/os',
                  enabled: true
                )
              end

              it do
                expect(chef_run).to create_yum_repository('epel').with(
                  mirrorlist: nil,
                  baseurl: 'http://epel.osuosl.org/8/Everything/$basearch/',
                  gpgkey: 'http://epel.osuosl.org/RPM-GPG-KEY-EPEL-8',
                  enabled: true
                )
              end

              it do
                expect(chef_run).to_not create_yum_repository('elrepo')
              end
            
            else
              it do
                expect(chef_run).to create_yum_repository('base').with(
                  mirrorlist: nil,
                  baseurl: 'http://centos.osuosl.org/$releasever/BaseOS/$basearch/os',
                  enabled: true
                )
              end
  
              it do
                expect(chef_run).to create_yum_repository('appstream').with(
                  mirrorlist: nil,
                  baseurl: 'http://centos.osuosl.org/$releasever/AppStream/$basearch/os',
                  enabled: true
                )
              end
  
              it do
                expect(chef_run).to create_yum_repository('extras').with(
                  mirrorlist: nil,
                  baseurl: 'http://centos.osuosl.org/$releasever/extras/$basearch/os',
                  enabled: true
                )
              end
  
              it do
                expect(chef_run).to create_yum_repository('powertools').with(
                  mirrorlist: nil,
                  baseurl: 'http://centos.osuosl.org/$releasever/PowerTools/$basearch/os',
                  enabled: true
                )
              end
  
              it do
                expect(chef_run).to create_yum_repository('epel').with(
                  mirrorlist: nil,
                  baseurl: 'http://epel.osuosl.org/8/Everything/$basearch/',
                  gpgkey: 'http://epel.osuosl.org/RPM-GPG-KEY-EPEL-8',
                  enabled: true
                )
              end
  
              if arch == 'x86_64'
                it do
                  expect(chef_run).to create_yum_repository('elrepo').with(
                    mirrorlist: nil,
                    baseurl: 'http://ftp.osuosl.org/pub/elrepo/elrepo/el8/$basearch/',
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
        end
      end
    end
  end
end
