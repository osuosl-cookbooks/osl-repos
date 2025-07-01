#
# Cookbook:: osl-repos
# Spec:: centos_kmods
#
# Copyright:: 2024-2025, Oregon State University
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
describe 'osl-repos-test::centos_kmods' do
  [ALMA_8, ALMA_9, ALMA_10].each do |p|
    context "#{p[:platform]} #{p[:version]}" do
      cached(:chef_run) do
        ChefSpec::SoloRunner.new(p.dup.merge(step_into: :osl_repos_centos_kmods)).converge(described_recipe)
      end

      # Check for convergence
      it 'converges successfully' do
        expect { chef_run }.to_not raise_error
      end

      it do
        is_expected.to create_yum_repository('centos-kmods').with(
          description: 'CentOS $releasever - Kmods',
          url: 'https://centos-stream.osuosl.org/SIGs/$releasever/kmods/$basearch/packages-main/',
          gpgcheck: true,
          gpgkey: 'https://www.centos.org/keys/RPM-GPG-KEY-CentOS-SIG-Kmods'
        )
      end

      it do
        is_expected.to create_yum_repository('centos-kmods-rebuild').with(
          description: 'CentOS $releasever - Kmods - Rebuild',
          url: 'https://centos-stream.osuosl.org/SIGs/$releasever/kmods/$basearch/packages-rebuild/',
          gpgcheck: true,
          gpgkey: 'https://www.centos.org/keys/RPM-GPG-KEY-CentOS-SIG-Kmods'
        )
      end

      it do
        is_expected.to create_yum_repository('centos-kmods-userspace').with(
          description: 'CentOS $releasever - Kmods - User Space',
          url: 'https://centos-stream.osuosl.org/SIGs/$releasever/kmods/$basearch/packages-userspace/',
          gpgcheck: true,
          gpgkey: 'https://www.centos.org/keys/RPM-GPG-KEY-CentOS-SIG-Kmods'
        )
      end

      it do
        is_expected.to create_yum_repository('centos-kmods-kernel-6.1').with(
          description: 'CentOS $releasever - Kmods - Kernel - 6.1',
          url: 'https://centos-stream.osuosl.org/SIGs/$releasever/kmods/$basearch/kernel-6.1/',
          gpgcheck: true,
          gpgkey: 'https://www.centos.org/keys/RPM-GPG-KEY-CentOS-SIG-Kmods'
        )
      end

      it do
        is_expected.to create_yum_repository('centos-kmods-kernel-6.6').with(
          description: 'CentOS $releasever - Kmods - Kernel - 6.6',
          url: 'https://centos-stream.osuosl.org/SIGs/$releasever/kmods/$basearch/kernel-6.6/',
          gpgcheck: true,
          gpgkey: 'https://www.centos.org/keys/RPM-GPG-KEY-CentOS-SIG-Kmods'
        )
      end

      if p[:version].to_i >= 9
        it do
          is_expected.to create_yum_repository('centos-kmods-kernel-latest').with(
            description: 'CentOS $releasever - Kmods - Kernel',
            url: 'https://centos-stream.osuosl.org/SIGs/$releasever/kmods/$basearch/kernel-latest/',
            gpgcheck: true,
            gpgkey: 'https://www.centos.org/keys/RPM-GPG-KEY-CentOS-SIG-Kmods'
          )
        end
      else
        it { is_expected.to_not create_yum_repository 'centos-kmods-kernel-latest' }
      end
    end
  end
end
