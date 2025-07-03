module OslRepos
  module Cookbook
    module Helpers
      def release_var
        '$releasever'
      end

      # Select the epel baseurl based on centos version
      def epel_baseurl
        'https://epel.osuosl.org/$releasever/Everything/$basearch/'
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

      def repo_resource_exist?(resource)
        !find_resource!(:yum_repository, resource).nil?
      rescue Chef::Exceptions::ResourceNotFound
        false
      end

      # List all known parameters for yum_repository
      # https://docs.chef.io/resources/yum_repository/
      def yum_repo_parameters
        %w(
          baseurl
          clean_metadata
          cost
          description
          enabled
          enablegroups
          exclude
          failovermethod
          fastestmirror_enabled
          gpgcheck
          gpgkey
          http_caching
          include_config
          includepkgs
          keepalive
          make_cache
          makecache_fast
          max_retries
          metadata_expire
          metalink
          mirror_expire
          mirrorlist
          mirrorlist_expire
          mode
          options
          password
          priority
          proxy
          proxy_password
          proxy_username
          repo_gpgcheck
          report_instanceid
          reposdir
          repositoryid
          skip_if_unavailable
          source
          sslcacert
          sslclientcert
          sslclientkey
          sslverify
          throttle
          timeout
          username
          action
        )
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
    end
  end
end
Chef::DSL::Recipe.include ::OslRepos::Cookbook::Helpers
Chef::Resource.include ::OslRepos::Cookbook::Helpers
