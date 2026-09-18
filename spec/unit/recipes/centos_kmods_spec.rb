#
# Cookbook:: osl-repos
# Spec:: centos_kmods
#
# Copyright:: 2024-2026, Oregon State University
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
  gpgkey = 'https://www.centos.org/keys/RPM-GPG-KEY-CentOS-SIG-Kmods'
  streams = %w(6.1 6.6 6.12 6.18 latest)

  [ALMA_8, ALMA_9, ALMA_10].each do |p|
    context "#{p[:platform]} #{p[:version]}" do
      cached(:chef_run) do
        ChefSpec::SoloRunner.new(p.dup.merge(step_into: :osl_repos_centos_kmods)).converge(described_recipe)
      end
      kernel = p[:version].to_i < 9 ? '6.6' : '6.18'

      # Check for convergence
      it 'converges successfully' do
        expect { chef_run }.to_not raise_error
      end

      it do
        is_expected.to create_yum_repository('centos-kmods').with(
          description: 'CentOS $releasever - Kmods',
          url: 'https://centos-stream.osuosl.org/SIGs/$releasever/kmods/$basearch/packages-main/',
          gpgcheck: true,
          gpgkey: gpgkey
        )
      end

      it do
        is_expected.to create_yum_repository('centos-kmods-rebuild').with(
          description: 'CentOS $releasever - Kmods - Rebuild',
          url: 'https://centos-stream.osuosl.org/SIGs/$releasever/kmods/$basearch/packages-rebuild/',
          gpgcheck: true,
          gpgkey: gpgkey
        )
      end

      it do
        is_expected.to create_yum_repository('centos-kmods-userspace').with(
          description: 'CentOS $releasever - Kmods - User Space',
          url: 'https://centos-stream.osuosl.org/SIGs/$releasever/kmods/$basearch/packages-userspace/',
          gpgcheck: true,
          gpgkey: gpgkey
        )
      end

      it do
        is_expected.to create_yum_repository("centos-kmods-kernel-#{kernel}").with(
          description: "CentOS $releasever - Kmods - Kernel - #{kernel}",
          url: "https://centos-stream.osuosl.org/SIGs/$releasever/kmods/$basearch/kernel-#{kernel}/",
          gpgcheck: true,
          gpgkey: gpgkey,
          exclude: 'kernel-headers kernel-cross-headers'
        )
      end

      (streams - [kernel]).each do |other|
        it { is_expected.to_not create_yum_repository "centos-kmods-kernel-#{other}" }
      end
    end
  end

  context 'kernel stream not published for the release' do
    cached(:chef_run) do
      ChefSpec::SoloRunner.new(ALMA_8.dup.merge(step_into: :osl_repos_centos_kmods))
                          .converge('osl-repos-test::centos_kmods_unavailable')
    end

    it { expect { chef_run }.to raise_error(RuntimeError, /does not publish kernel-latest for EL8 \(available: 6.1, 6.6\)/) }
  end
end
