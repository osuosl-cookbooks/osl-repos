module OslRepos
  module Cookbook
    module Helpers
      # Define variables to use in repo urls
      def centos_url
        # CentOS 7 splits up ppc64 and aarch64 into a secondary architecture repo.
        if node['platform_version'].to_i < 8
          case node['kernel']['machine']
          when 'aarch64', 'ppc64le', 's390x'
            url = 'https://centos-altarch.osuosl.org'
          else
            url = 'https://centos.osuosl.org'
          end
        else
          url = 'https://centos.osuosl.org'
        end
        url
      end

      # power9 replaces $basearch in power9 repositories
      def base_arch
        if power9?
          'power9'
        else
          '$basearch'
        end
      end

      # Is this a power9 architecture?
      def power9?
        if node['ibm_power'] && node['ibm_power']['cpu']
          if node['kernel']['machine'] == 'ppc64le' || !node['ibm_power'].nil?
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
