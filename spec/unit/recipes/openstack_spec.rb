#
# Cookbook:: osl-repos
# Spec:: elevate
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
      when ALMA_9
        it { expect(chef_run).to_not install_package 'yum-plugin-priorities' }
        it do
          expect(chef_run).to create_yum_repository('RDO-openstack').with(
            description: 'OpenStack RDO yoga',
            url: 'https://centos-stream.osuosl.org/SIGs/$releasever-stream/cloud/$basearch/openstack-yoga',
            gpgcheck: true,
            gpgkey: 'https://www.centos.org/keys/RPM-GPG-KEY-CentOS-SIG-Cloud'
          )
        end
      when ALMA_8
        it { expect(chef_run).to_not install_package 'yum-plugin-priorities' }
        it do
          expect(chef_run).to create_yum_repository('RDO-openstack').with(
            description: 'OpenStack RDO train',
            url: 'https://ftp.osuosl.org/pub/osl/rdo/$releasever/$basearch/openstack-train',
            gpgcheck: true,
            gpgkey: 'https://www.centos.org/keys/RPM-GPG-KEY-CentOS-SIG-Cloud'
          )
        end
      when CENTOS_7
        it { expect(chef_run).to install_package 'yum-plugin-priorities' }
        it do
          expect(chef_run).to create_yum_repository('RDO-openstack').with(
            description: 'OpenStack RDO train',
            url: 'https://centos.osuosl.org/$releasever/cloud/$basearch/openstack-train',
            gpgcheck: true,
            gpgkey: 'https://www.centos.org/keys/RPM-GPG-KEY-CentOS-SIG-Cloud'
          )
        end
      end

      %w(aarch64 ppc64le).each do |arch|
        context arch do
          cached(:chef_run) do
            ChefSpec::SoloRunner.new(p.dup.merge(step_into: [:osl_repos_openstack])) do |node|
              node.automatic['kernel']['machine'] = arch
            end.converge(described_recipe)
          end
          case p
          when ALMA_9
            it { expect(chef_run).to_not install_package 'yum-plugin-priorities' }
            it do
              expect(chef_run).to create_yum_repository('RDO-openstack').with(
                description: 'OpenStack RDO yoga',
                url: 'https://centos-stream.osuosl.org/SIGs/$releasever-stream/cloud/$basearch/openstack-yoga',
                gpgcheck: true,
                gpgkey: 'https://www.centos.org/keys/RPM-GPG-KEY-CentOS-SIG-Cloud'
              )
            end
          when ALMA_8
            it { expect(chef_run).to_not install_package 'yum-plugin-priorities' }
            it do
              expect(chef_run).to create_yum_repository('RDO-openstack').with(
                description: 'OpenStack RDO train',
                url: 'https://ftp.osuosl.org/pub/osl/rdo/$releasever/$basearch/openstack-train',
                gpgcheck: true,
                gpgkey: 'https://www.centos.org/keys/RPM-GPG-KEY-CentOS-SIG-Cloud'
              )
            end
          when CENTOS_7
            it { expect(chef_run).to install_package 'yum-plugin-priorities' }
            it do
              expect(chef_run).to create_yum_repository('RDO-openstack').with(
                description: 'OpenStack RDO train',
                url: 'https://centos-altarch.osuosl.org/$releasever/cloud/$basearch/openstack-train',
                gpgcheck: true,
                gpgkey: 'https://www.centos.org/keys/RPM-GPG-KEY-CentOS-SIG-Cloud'
              )
            end
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
      when ALMA_9
        it { expect(chef_run).to_not install_package 'yum-plugin-priorities' }
        it do
          expect(chef_run).to create_yum_repository('RDO-openstack').with(
            description: 'OpenStack RDO yoga',
            url: 'https://centos-stream.osuosl.org/SIGs/$releasever-stream/cloud/$basearch/openstack-yoga',
            gpgcheck: true,
            gpgkey: 'https://www.centos.org/keys/RPM-GPG-KEY-CentOS-SIG-Cloud'
          )
        end
      when ALMA_8
        it { expect(chef_run).to_not install_package 'yum-plugin-priorities' }
        it do
          expect(chef_run).to create_yum_repository('RDO-openstack').with(
            description: 'OpenStack RDO train',
            url: 'https://ftp.osuosl.org/pub/osl/rdo/$releasever/$basearch/openstack-train',
            gpgcheck: true,
            gpgkey: 'https://www.centos.org/keys/RPM-GPG-KEY-CentOS-SIG-Cloud'
          )
        end
      when CENTOS_7
        it { expect(chef_run).to install_package 'yum-plugin-priorities' }
        it do
          expect(chef_run).to create_yum_repository('RDO-openstack').with(
            description: 'OpenStack RDO train',
            url: 'https://centos.osuosl.org/$releasever/cloud/$basearch/openstack-train',
            gpgcheck: true,
            gpgkey: 'https://www.centos.org/keys/RPM-GPG-KEY-CentOS-SIG-Cloud'
          )
        end
      end

      context 'set attribute' do
        cached(:chef_run) do
          ChefSpec::SoloRunner.new(p.dup.merge(step_into: [:osl_repos_openstack])) do |node|
            node.normal['osl-repos']['openstack']['version'] = 'xena'
          end.converge(described_recipe)
        end
        case p
        when ALMA_9
          it { expect(chef_run).to_not install_package 'yum-plugin-priorities' }
          it do
            expect(chef_run).to create_yum_repository('RDO-openstack').with(
              description: 'OpenStack RDO xena',
              url: 'https://centos-stream.osuosl.org/SIGs/$releasever-stream/cloud/$basearch/openstack-xena',
              gpgcheck: true,
              gpgkey: 'https://www.centos.org/keys/RPM-GPG-KEY-CentOS-SIG-Cloud'
            )
          end
        when ALMA_8
          it { expect(chef_run).to_not install_package 'yum-plugin-priorities' }
          it do
            expect(chef_run).to create_yum_repository('RDO-openstack').with(
              description: 'OpenStack RDO xena',
              url: 'https://ftp.osuosl.org/pub/osl/rdo/$releasever/$basearch/openstack-xena',
              gpgcheck: true,
              gpgkey: 'https://www.centos.org/keys/RPM-GPG-KEY-CentOS-SIG-Cloud'
            )
          end
        when CENTOS_7
          it { expect(chef_run).to install_package 'yum-plugin-priorities' }
          it do
            expect(chef_run).to create_yum_repository('RDO-openstack').with(
              description: 'OpenStack RDO xena',
              url: 'https://centos.osuosl.org/$releasever/cloud/$basearch/openstack-xena',
              gpgcheck: true,
              gpgkey: 'https://www.centos.org/keys/RPM-GPG-KEY-CentOS-SIG-Cloud'
            )
          end
        end
      end
    end
  end
end
