# Cookbook:: osl-repos
# Spec:: elrepo
#
# Copyright:: 2020-2021, Oregon State University
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
describe 'osl-repos::elrepo' do
  ALL_PLATFORMS.each do |p|
    context "#{p[:platform]} #{p[:version]}" do
      cached(:chef_run) do
        # Here we step into our :osl_repos_elrepo resource, this enables us to test the resources created within it
        ChefSpec::SoloRunner.new(p.dup.merge(step_into: [:osl_repos_elrepo])).converge(described_recipe)
      end

      # Check for convergence
      it 'converges successfully' do
        expect { chef_run }.to_not raise_error
      end

      # There will be different cases for the Centos 7 and Centos 8 repositories
      case p[:version].to_i

      # Begin Centos 7 case
      when 7

        # We need to test each supported architecture
        # This loop creates a context for each architecture and applies its tests.
        %w(x86_64 aarch64 s390x).each do |arch|
          context "arch #{arch}" do
            cached(:chef_run) do
              ChefSpec::SoloRunner.new(p.dup.merge(step_into: [:osl_repos_elrepo])) do |node|
                # Here we set the architecture to match our current iteration of the loop
                node.automatic['kernel']['machine'] = arch
              end.converge(described_recipe)
            end

            # The elrepo repositorry should be installed on the x86_64 architecture
            if arch == 'x86_64'
              it do
                expect(chef_run).to create_yum_repository('elrepo').with(
                  mirrorlist: nil,
                  baseurl: 'https://ftp.osuosl.org/pub/elrepo/elrepo/el$releasever/$basearch/',
                  enabled: true
                )
              end

            # Non x86_64 architectures should not install the elrepo repository
            else
              it do
                expect(chef_run).to_not create_yum_repository('elrepo')
              end
            end
          end # End architecture context
        end # End Centos 7 architecture loop

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

            # Non x86_64 architectures should not install the elrepo repository
            it do
              expect(chef_run).to_not create_yum_repository('elrepo')
            end
          end # End ppc Context
        end # End ppc Switchcase

      # Begin Centos 8 Case
      when 8

        # We need to test each supported architecture
        # This loop creates a context for each architecture and applies its tests.
        %w(x86_64 aarch64 s390x).each do |arch|
          context "arch #{arch}" do
            cached(:chef_run) do
              ChefSpec::SoloRunner.new(p.dup.merge(step_into: [:osl_repos_elrepo])) do |node|
                # Here we set the architecture to match our current iteration of the loop
                node.automatic['kernel']['machine'] = arch
              end.converge(described_recipe)
            end

            # The elrepo repositorry should be installed on the x86_64 architecture
            if arch == 'x86_64'
              it do
                expect(chef_run).to create_yum_repository('elrepo').with(
                  mirrorlist: nil,
                  baseurl: 'https://ftp.osuosl.org/pub/elrepo/elrepo/el$releasever/$basearch/',
                  enabled: true
                )
              end

            # Non x86_64 architectures should not install the elrepo repository
            else
              it do
                expect(chef_run).to_not create_yum_repository('elrepo')
              end
            end
          end # End architecture context
        end # End Centos 8 architecture loop

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

            # Non x86_64 architectures should not install the elrepo repository
            it do
              expect(chef_run).to_not create_yum_repository('elrepo')
            end
          end # End ppc Context
        end # End ppc Switchcase

      end # End Centos Version Switchcase
    end
  end
end
