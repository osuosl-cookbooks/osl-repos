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

####### Begin Spec Tests #######
describe 'osl-repos::elrepo' do
  ALL_PLATFORMS.each do |p|
    context "#{p[:platform]} #{p[:version]}" do
      cached(:chef_run) do
        # Here we step into our :osl_repos_centos resource, this enables us to test the resources created within it
        ChefSpec::SoloRunner.new(p.dup.merge(step_into: [:osl_repos_centos])) do |node|
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

      # There will be different cases for the Centos 7 and Centos 8 repositories
      case p[:version].to_i

      ############## Begin Centos 7 case ##############
      when 7

        # We need to test each supported architecture
        # This loop creates a context for each architecture and applies its tests.
        %w(x86_64 i386 aarch64 ppc64 ppc64le s390x).each do |arch|
          context "arch #{arch}" do
            cached(:chef_run) do
              ChefSpec::SoloRunner.new(p.dup.merge(step_into: [:osl_repos_centos])) do |node|
                # Here we set the architecture to match our current iteration of the loop
                node.automatic['kernel']['machine'] = arch

                # If the architecture is ppc64 or ppc64le we manually set the recognized cpu model to power 9
                # This is important to set here because it is included in our repo url
                if arch =~ /(ppc64|ppc64le)/
                  node.automatic['ibm_power']['cpu']['cpu_model'] = 'power9'
                end
              end.converge(described_recipe)
            end

            ### The following will test for the correct settings being applied to each Centos 7 repository
            ### ( Based on the default values for managed and enabled being set to true )

            # The base url of our repos is determined by the architecture, we need to create different cases for each
            # of the non-standard affected architectures.
            # These architectures will all use the baseurl prefix 'http://centos-altarch.osuosl.org'
            case arch

            ####### Begin alt-arch case #######
            when 'aarch64', 'ppc64', 'ppc64le', 's390x'

              # The power9 architectures will have a different basearch than aarch64 and s390x, so we create another
              # case for them
              case arch

              ####### Begin power9 case #######
              when 'ppc64', 'ppc64le'

                # NOTE: Each repo in this section will contain the string 'power9' in its baseurl instead of '$basearch'

                # Test the base repository
                it do
                  expect(chef_run).to_not create_yum_repository('base')
                end

                # Test the extras repository
                it do
                  expect(chef_run).to_not create_yum_repository('extras')
                end

                # Test the updates repository
                it do
                  expect(chef_run).to_not create_yum_repository('updates')
                end

              ####### Begin 'aarch64', 's390x' case #######
              when 'aarch64', 's390x'

                # Test the base repository
                it do
                  expect(chef_run).to_not create_yum_repository('base')
                end

                # Test the extras repository
                it do
                  expect(chef_run).to_not create_yum_repository('extras')
                end

                # Test the updates repository
                it do
                  expect(chef_run).to_not create_yum_repository('updates')
                end

              end ####### End of alt-arch case #######

            ####### Begin standard architecture case #######
            when 'x86_64', 'i386'

              # NOTE: The baseurl prefix of these repos is 'http://centos.osuosl.org'

              # Test the base repository
              it do
                expect(chef_run).to_not create_yum_repository('base')
              end

              # Test the extras repository
              it do
                expect(chef_run).to_not create_yum_repository('extras')
              end

              # Test the updates repository
              it do
                expect(chef_run).to_not create_yum_repository('updates')
              end

            end ####### End alternate architecture switcase #######

            # Test the epel repository
            # This repository is outside of the switchcase because it is the same across all architectures
            it do
              expect(chef_run).to_not create_yum_repository('epel')
            end
          end ####### End Centos 7 Architecture Loop #######
        end

      ############## Begin Centos 8 Case ##############
      when 8

        # We need to test each supported architecture
        # This loop creates a context for each architecture and applies its tests.
        %w(x86_64 i386 aarch64 ppc64 ppc64le s390x).each do |arch|
          context "arch #{arch}" do
            cached(:chef_run) do
              ChefSpec::SoloRunner.new(p.dup.merge(step_into: [:osl_repos_centos])) do |node|
                # If the architecture is ppc64 or ppc64le we manually set the recognized cpu model to power 9
                # This is important to set here because it is included in our repo url
                node.automatic['kernel']['machine'] = arch
                if arch =~ /(ppc64|ppc64le)/
                  node.automatic['ibm_power']['cpu']['cpu_model'] = 'power9'
                end
              end.converge(described_recipe)
            end

            ### The following will test for the correct settings being applied to each Centos 7 repository
            ### ( Based on the default values for managed and enabled being set to true )

            # The power9 architectures will have a different basearch than the other architectures, so we create a
            # switchcase for them
            case arch

            ####### Begin power9 case #######
            when 'ppc64', 'ppc64le'

              # NOTE: Each repo in this section will contain the string 'power9' in its baseurl instead of '$basearch'

              # Test the appstream repository
              it do
                expect(chef_run).to_not create_yum_repository('appstream')
              end

              # Test the base repository
              it do
                expect(chef_run).to_not create_yum_repository('base')
              end

              # Test the extras repository
              it do
                expect(chef_run).to_not create_yum_repository('extras')
              end

              # Test the powertools repository
              it do
                expect(chef_run).to_not create_yum_repository('powertools')
              end

            ####### Begin 'x86_64', 'i386', 'aarch64', and 's390x' case #######
            when 'x86_64', 'i386', 'aarch64', 's390x'

              # Test the appstream repository
              it do
                expect(chef_run).to_not create_yum_repository('appstream')
              end

              # Test the base repository
              it do
                expect(chef_run).to_not create_yum_repository('base')
              end

              # Test the extras repository
              it do
                expect(chef_run).to_not create_yum_repository('extras')
              end

              # Test the powertools repository
              it do
                expect(chef_run).to_not create_yum_repository('powertools')
              end

            end ####### End switchcase #######

            # The elrepo repositorry should be installed on the x86_64 architecture
            if arch == 'x86_64'
              it do
                expect(chef_run).to create_yum_repository('elrepo').with(
                  mirrorlist: nil,
                  baseurl: 'http://ftp.osuosl.org/pub/elrepo/elrepo/el8/$basearch/',
                  enabled: true
                )
              end

            # Non x86_64 architectures should not install the elrepo repository
            else
              it do
                expect(chef_run).to_not create_yum_repository('elrepo')
              end
            end
          end ####### End architecture context #######

          # The epel repository is common across all architectures and Centos Versions so it is excluded from the switchcase

          # Test the epel repository
          it do
            expect(chef_run).to_not create_yum_repository('epel')
          end
        end ####### End Centos 8 architecture loop #######

      end ############## End Centos Version Switchcase ##############
    end
  end
end