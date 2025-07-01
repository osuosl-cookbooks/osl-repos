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

describe 'osl-repos-test::openstack' do
  ALL_RHEL.each do |p|
    context "#{p[:platform]} #{p[:version]}" do
      cached(:chef_run) do
        ChefSpec::SoloRunner.new(p.dup.merge(step_into: [:osl_repos_openstack])).converge(described_recipe)
      end
      it 'converges successfully' do
        expect { chef_run }.to_not raise_error
      end
      case p
      when ALMA_10
        it do
          expect(chef_run).to create_yum_repository('RDO-openstack').with(
            description: 'OpenStack RDO epoxy',
            url: 'https://centos-stream.osuosl.org/SIGs/$releasever-stream/cloud/$basearch/openstack-epoxy',
            gpgcheck: true,
            gpgkey: 'https://www.centos.org/keys/RPM-GPG-KEY-CentOS-SIG-Cloud'
          )
        end
        it do
          is_expected.to create_yum_repository('OSL-openstack').with(
            description: 'OpenStack OSL epoxy',
            baseurl: 'https://ftp.osuosl.org/pub/osl/repos/yum/$releasever/openstack-epoxy/$basearch',
            gpgkey: 'https://ftp.osuosl.org/pub/osl/repos/yum/RPM-GPG-KEY-osuosl-2024',
            priority: '10'
          )
        end
        it do
          is_expected.to create_yum_repository('centos-nfv').with(
            description: 'CentOS $releasever - NFV',
            baseurl: 'https://centos-stream.osuosl.org/SIGs/$releasever-stream/nfv/$basearch/openvswitch-2',
            gpgkey: 'https://centos.org/keys/RPM-GPG-KEY-CentOS-SIG-NFV'
          )
        end
      when ALMA_9
        it do
          expect(chef_run).to create_yum_repository('RDO-openstack').with(
            description: 'OpenStack RDO yoga',
            url: 'https://centos-stream.osuosl.org/SIGs/$releasever-stream/cloud/$basearch/openstack-yoga',
            gpgcheck: true,
            gpgkey: 'https://www.centos.org/keys/RPM-GPG-KEY-CentOS-SIG-Cloud'
          )
        end
        it do
          is_expected.to create_yum_repository('OSL-openstack').with(
            description: 'OpenStack OSL yoga',
            baseurl: 'https://ftp.osuosl.org/pub/osl/repos/yum/$releasever/openstack-yoga/$basearch',
            gpgkey: 'https://ftp.osuosl.org/pub/osl/repos/yum/RPM-GPG-KEY-osuosl-2024',
            priority: '10'
          )
        end
        it do
          is_expected.to create_yum_repository('centos-nfv').with(
            description: 'CentOS $releasever - NFV',
            baseurl: 'https://centos-stream.osuosl.org/SIGs/$releasever-stream/nfv/$basearch/openvswitch-2',
            gpgkey: 'https://centos.org/keys/RPM-GPG-KEY-CentOS-SIG-NFV'
          )
        end
        it { is_expected.to_not create_yum_repository 'OSL-openstack-power10' }
      when ALMA_8
        it do
          expect(chef_run).to create_yum_repository('RDO-openstack').with(
            description: 'OpenStack RDO yoga',
            url: 'https://ftp.osuosl.org/pub/osl/rdo/$releasever/$basearch/openstack-yoga',
            gpgcheck: true,
            gpgkey: 'https://www.centos.org/keys/RPM-GPG-KEY-CentOS-SIG-Cloud'
          )
        end
        it do
          is_expected.to create_yum_repository('OSL-openstack').with(
            description: 'OpenStack OSL yoga',
            baseurl: 'https://ftp.osuosl.org/pub/osl/repos/yum/$releasever/openstack-yoga/$basearch',
            gpgkey: 'https://ftp.osuosl.org/pub/osl/repos/yum/RPM-GPG-KEY-osuosl',
            priority: '10'
          )
        end
        it do
          is_expected.to create_yum_repository('centos-nfv').with(
            description: 'CentOS $releasever - NFV',
            baseurl: 'https://ftp.osuosl.org/pub/osl/vault/$releasever-stream/nfv/$basearch/openvswitch-2',
            gpgkey: 'https://centos.org/keys/RPM-GPG-KEY-CentOS-SIG-NFV'
          )
        end
        it { is_expected.to_not create_yum_repository 'OSL-openstack-power10' }
      end

      %w(aarch64 ppc64le).each do |arch|
        context arch do
          cached(:chef_run) do
            ChefSpec::SoloRunner.new(p.dup.merge(step_into: [:osl_repos_openstack])) do |node|
              node.automatic['kernel']['machine'] = arch
            end.converge(described_recipe)
          end
          case p
          when ALMA_10
            it do
              expect(chef_run).to create_yum_repository('RDO-openstack').with(
                description: 'OpenStack RDO epoxy',
                url: 'https://centos-stream.osuosl.org/SIGs/$releasever-stream/cloud/$basearch/openstack-epoxy',
                gpgcheck: true,
                gpgkey: 'https://www.centos.org/keys/RPM-GPG-KEY-CentOS-SIG-Cloud'
              )
            end
            it do
              is_expected.to create_yum_repository('OSL-openstack').with(
                description: 'OpenStack OSL epoxy',
                baseurl: 'https://ftp.osuosl.org/pub/osl/repos/yum/$releasever/openstack-epoxy/$basearch',
                gpgkey: 'https://ftp.osuosl.org/pub/osl/repos/yum/RPM-GPG-KEY-osuosl-2024',
                priority: '10'
              )
            end
            it { is_expected.to_not create_yum_repository 'OSL-openstack-power10' }
          when ALMA_9
            it do
              expect(chef_run).to create_yum_repository('RDO-openstack').with(
                description: 'OpenStack RDO yoga',
                url: 'https://centos-stream.osuosl.org/SIGs/$releasever-stream/cloud/$basearch/openstack-yoga',
                gpgcheck: true,
                gpgkey: 'https://www.centos.org/keys/RPM-GPG-KEY-CentOS-SIG-Cloud'
              )
            end
            it do
              is_expected.to create_yum_repository('OSL-openstack').with(
                description: 'OpenStack OSL yoga',
                baseurl: 'https://ftp.osuosl.org/pub/osl/repos/yum/$releasever/openstack-yoga/$basearch',
                gpgkey: 'https://ftp.osuosl.org/pub/osl/repos/yum/RPM-GPG-KEY-osuosl-2024',
                priority: '10'
              )
            end
            it { is_expected.to_not create_yum_repository 'OSL-openstack-power10' }
          when ALMA_8
            it do
              expect(chef_run).to create_yum_repository('RDO-openstack').with(
                description: 'OpenStack RDO yoga',
                url: 'https://ftp.osuosl.org/pub/osl/rdo/$releasever/$basearch/openstack-yoga',
                gpgcheck: true,
                gpgkey: 'https://www.centos.org/keys/RPM-GPG-KEY-CentOS-SIG-Cloud'
              )
            end
            it do
              is_expected.to create_yum_repository('OSL-openstack').with(
                description: 'OpenStack OSL yoga',
                baseurl: 'https://ftp.osuosl.org/pub/osl/repos/yum/$releasever/openstack-yoga/$basearch',
                gpgkey: 'https://ftp.osuosl.org/pub/osl/repos/yum/RPM-GPG-KEY-osuosl',
                priority: '10'
              )
            end
            it { is_expected.to_not create_yum_repository 'OSL-openstack-power10' }
          end
        end
      end

      context 'ppc64le POWER10' do
        cached(:chef_run) do
          ChefSpec::SoloRunner.new(p.dup.merge(step_into: [:osl_repos_openstack])) do |node|
            node.automatic['kernel']['machine'] = 'ppc64le'
            node.automatic['cpu']['model_name'] = 'POWER10 (raw), altivec supported'
          end.converge(described_recipe)
        end
        case p
        when ALMA_10
          it do
            is_expected.to create_yum_repository('OSL-openstack-power10').with(
              description: 'OpenStack OSL epoxy - POWER10',
              baseurl: 'https://ftp.osuosl.org/pub/osl/repos/yum/$releasever/openstack-epoxy-power10/$basearch',
              gpgkey: 'https://ftp.osuosl.org/pub/osl/repos/yum/RPM-GPG-KEY-osuosl-2024',
              priority: '10',
              options: { module_hotfixes: '1' }
            )
          end
        when ALMA_9
          it do
            is_expected.to create_yum_repository('OSL-openstack-power10').with(
              description: 'OpenStack OSL yoga - POWER10',
              baseurl: 'https://ftp.osuosl.org/pub/osl/repos/yum/$releasever/openstack-yoga-power10/$basearch',
              gpgkey: 'https://ftp.osuosl.org/pub/osl/repos/yum/RPM-GPG-KEY-osuosl-2024',
              priority: '10',
              options: { module_hotfixes: '1' }
            )
          end
        when ALMA_8
          it do
            is_expected.to create_yum_repository('OSL-openstack-power10').with(
              description: 'OpenStack OSL yoga - POWER10',
              baseurl: 'https://ftp.osuosl.org/pub/osl/repos/yum/$releasever/openstack-yoga-power10/$basearch',
              gpgkey: 'https://ftp.osuosl.org/pub/osl/repos/yum/RPM-GPG-KEY-osuosl',
              priority: '10',
              options: { module_hotfixes: '1' }
            )
          end
        end
      end
    end
  end
end

describe 'osl-repos::openstack' do
  ALL_RHEL.each do |p|
    context "#{p[:platform]} #{p[:version]}" do
      cached(:chef_run) do
        ChefSpec::SoloRunner.new(p.dup.merge(step_into: [:osl_repos_openstack])).converge(described_recipe)
      end
      it 'converges successfully' do
        expect { chef_run }.to_not raise_error
      end
      case p
      when ALMA_10
        it do
          expect(chef_run).to create_yum_repository('RDO-openstack').with(
            description: 'OpenStack RDO epoxy',
            url: 'https://centos-stream.osuosl.org/SIGs/$releasever-stream/cloud/$basearch/openstack-epoxy',
            gpgcheck: true,
            gpgkey: 'https://www.centos.org/keys/RPM-GPG-KEY-CentOS-SIG-Cloud'
          )
        end
      when ALMA_9
        it do
          expect(chef_run).to create_yum_repository('RDO-openstack').with(
            description: 'OpenStack RDO yoga',
            url: 'https://centos-stream.osuosl.org/SIGs/$releasever-stream/cloud/$basearch/openstack-yoga',
            gpgcheck: true,
            gpgkey: 'https://www.centos.org/keys/RPM-GPG-KEY-CentOS-SIG-Cloud'
          )
        end
      when ALMA_8
        it do
          expect(chef_run).to create_yum_repository('RDO-openstack').with(
            description: 'OpenStack RDO yoga',
            url: 'https://ftp.osuosl.org/pub/osl/rdo/$releasever/$basearch/openstack-yoga',
            gpgcheck: true,
            gpgkey: 'https://www.centos.org/keys/RPM-GPG-KEY-CentOS-SIG-Cloud'
          )
        end
      end

      context 'set attribute' do
        cached(:chef_run) do
          ChefSpec::SoloRunner.new(p.dup.merge(step_into: [:osl_repos_openstack])) do |node|
            node.normal['osl-repos']['openstack']['version'] =
              case p
              when ALMA_10
                'epoxy'
              else
                'yoga'
              end
          end.converge(described_recipe)
        end
        case p
        when ALMA_10
          it do
            expect(chef_run).to create_yum_repository('RDO-openstack').with(
              description: 'OpenStack RDO epoxy',
              url: 'https://centos-stream.osuosl.org/SIGs/$releasever-stream/cloud/$basearch/openstack-epoxy',
              gpgcheck: true,
              gpgkey: 'https://www.centos.org/keys/RPM-GPG-KEY-CentOS-SIG-Cloud'
            )
          end
        when ALMA_9
          it do
            expect(chef_run).to create_yum_repository('RDO-openstack').with(
              description: 'OpenStack RDO yoga',
              url: 'https://centos-stream.osuosl.org/SIGs/$releasever-stream/cloud/$basearch/openstack-yoga',
              gpgcheck: true,
              gpgkey: 'https://www.centos.org/keys/RPM-GPG-KEY-CentOS-SIG-Cloud'
            )
          end
        when ALMA_8
          it do
            expect(chef_run).to create_yum_repository('RDO-openstack').with(
              description: 'OpenStack RDO yoga',
              url: 'https://ftp.osuosl.org/pub/osl/rdo/$releasever/$basearch/openstack-yoga',
              gpgcheck: true,
              gpgkey: 'https://www.centos.org/keys/RPM-GPG-KEY-CentOS-SIG-Cloud'
            )
          end
        end
      end
    end
  end
end
