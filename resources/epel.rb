resource_name :osl_repos_epel
provides :osl_repos_epel
unified_mode true

default_action :add

# Whether the epel repo is managed
property :epel, [true, false], default: true

# Whether the epel repo is enabled
property :epel_enabled, [true, false], default: true
property :exclude, Array, default: []

# The default and only action
action :add do
  if platform_family?('rhel')
    # yum-epel 6.x is resource only, yum_epel_repository wraps yum_repository directly
    yum_epel_repository 'epel' do
      baseurl epel_baseurl
      mirrorlist nil
      gpgkey "https://epel.osuosl.org/RPM-GPG-KEY-EPEL-#{node['platform_version'].to_i}"
      # No exclude property, options is merged into the yum_repository config
      options({ exclude: new_resource.exclude.join(' ') }) unless new_resource.exclude.empty?
      # Written even when off, so an epel.repo from epel-release ends up disabled
      enabled new_resource.epel && new_resource.epel_enabled
    end
  end
end
