module OslRepos
  module Cookbook
    module Helpers
      # Define variables to use in repo urls
      def centos_url
        # CentOS 7 splits up ppc64 and aarch64 into a secondary architecture repo.
        if node['platform_version'].to_i < 8
          case node['kernel']['machine']
          when 'x86_64', 'i386'
            url = 'https://centos.osuosl.org'
          when 'aarch64', 'ppc64', 'ppc64le'
            url = 'https://centos-altarch.osuosl.org'
          when 's390x'
            node.default['yum']['epel']['enabled'] = false
            url = 'https://centos-altarch.osuosl.org'
          end
        else
          url = 'https://centos.osuosl.org'
        end
        url
      end

      # power9 replaces $basearch in power9 repositories
      def base_arch
        power9? ? 'power9' : '$basearch'
      end

      def power9?
        if node['ibm_power'] && node['ibm_power']['cpu']
          if node['kernel']['machine'] == 'ppc64' || node['kernel']['machine'] == 'ppc64le' || !node['ibm_power'].nil?
            node['ibm_power']['cpu']['cpu_model'] =~ /power9/
          else
            false
          end
        else
          false
        end
      end
    end
  end
end
Chef::DSL::Recipe.include ::OslRepos::Cookbook::Helpers
Chef::Resource.include ::OslRepos::Cookbook::Helpers
