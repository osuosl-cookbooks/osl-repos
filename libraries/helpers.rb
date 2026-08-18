module OslRepos
  module Cookbook
    module Helpers
      def release_var
        '$releasever'
      end

      # Select the epel baseurl based on centos version
      def epel_baseurl
        if node['platform_version'].to_i >= 10
          'https://epel.osuosl.org/$releasever${releasever_minor:+z}/Everything/$basearch/'
        else
          'https://epel.osuosl.org/$releasever/Everything/$basearch/'
        end
      end

      # Define variables to use in alma repo urls
      def alma_url
        'https://almalinux.osuosl.org'
      end

      def osl_repo_powertools_repo_name
        node['platform_version'].to_i >= 9 ? 'CRB' : 'PowerTools'
      end

      def osl_gpg_key
        if node['platform_version'].to_i >= 9
          gpgkey 'https://ftp.osuosl.org/pub/osl/repos/yum/RPM-GPG-KEY-osuosl-2024'
        else
          gpgkey 'https://ftp.osuosl.org/pub/osl/repos/yum/RPM-GPG-KEY-osuosl'
        end
      end

      def openstack_release
        case node['platform_version'].to_i
        when 10
          'epoxy'
        when 8, 9
          'yoga'
        end
      end

      def openstack_baseurl
        case node['platform_version'].to_i
        when 9, 10
          'https://centos-stream.osuosl.org/SIGs/$releasever-stream/cloud'
        when 8
          # TODO: Upstream has removed RDO from mirrors so this is a local mirror
          'https://ftp.osuosl.org/pub/osl/rdo/$releasever'
        end
      end

      def hashicorp_yum_baseurl
        case node['platform_version'].to_i
        when 10
          'https://rpm.releases.hashicorp.com/RHEL/9/$basearch/stable'
        when 8, 9
          'https://rpm.releases.hashicorp.com/RHEL/$releasever/$basearch/stable'
        end
      end

      def openstack_nfv_baseurl
        case node['platform_version'].to_i
        when 9, 10
          'https://centos-stream.osuosl.org/SIGs/$releasever-stream/nfv/$basearch/openvswitch-2'
        when 8
          # TODO: Upstream has removed RDO from mirrors so this is a local mirror
          'https://ftp.osuosl.org/pub/osl/vault/$releasever-stream/nfv/$basearch/openvswitch-2'
        end
      end

      # Lets a repo resource be declared more than once in a run: every declaration merges
      # into one config instead of the last one winning. Order independent, so each writes
      # identical content and the run stays idempotent.
      # union: arrays merged with |   all: booleans merged with && so any false wins
      def merge_shared_config(union: {}, all: {})
        config = ((node.run_state['osl-repos'] ||= {})[resource_name] ||= {})
        union.each { |name, value| config[name] = config.fetch(name, []) | Array(value) }
        all.each { |name, value| config[name] = config.fetch(name, true) && value }
        config
      end
    end
  end
end
Chef::DSL::Recipe.include ::OslRepos::Cookbook::Helpers
Chef::Resource.include ::OslRepos::Cookbook::Helpers
