module OslRepos
  module Cookbook
    module Helpers
      # Select the gpg key for use in centos 7
      # This ensures that the AltArch gpg key is included in any non x86_64 architecture
      def centos_7_gpgkey
        if node['kernel']['machine'] == 'x86_64'
          'file:///etc/pki/rpm-gpg/RPM-GPG-KEY-CentOS-7'
        else
          'file:///etc/pki/rpm-gpg/RPM-GPG-KEY-CentOS-7 file:///etc/pki/rpm-gpg/RPM-GPG-KEY-CentOS-SIG-AltArch-7-$basearch'
        end
      end

      # Select the epel baseurl based on centos version
      def epel_baseurl
        case node['platform_version'].to_i
        when 7
          node.default['yum']['epel']['baseurl'] = 'https://epel.osuosl.org/$releasever/$basearch/'
        when 8
          node.default['yum']['epel']['baseurl'] = 'https://epel.osuosl.org/$releasever/Everything/$basearch/'
        end
      end

      # Define variables to use in repo urls
      # CentOS 7 splits up ppc64 and aarch64 into a secondary architecture repo.
      def centos_url
        if node['platform_version'].to_i == 7
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
        if power9? && node['platform_version'].to_i == 7
          'power9'
        else
          '$basearch'
        end
      end

      # Is this a power9 architecture?
      def power9?
        if node['ibm_power'] && node['ibm_power']['cpu']
          if node['kernel']['machine'] == 'ppc64le'
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
