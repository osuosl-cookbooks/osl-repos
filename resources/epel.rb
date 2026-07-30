resource_name :osl_repos_epel
provides :osl_repos_epel
unified_mode true

default_action :add

# This property indicates whether the epel repo should be managed
property :epel, [true, false], default: true

# This property indicates whether or not the epel repo should be enabled
property :epel_enabled, [true, false], default: true
property :exclude, Array, default: []

# This is the default and only action, It will add all available repos, unless specified in properties above
action :add do
  # yum-epel 6.x is a resource-only cookbook
  # yum_epel_repository wrape Chef' built in yum_repository resource directly
  if new_resource.epel
    yum_epel_repository 'epel' do
      baseurl epel_baseurl
      mirrorlist nil
      gpgkey "https://epel.osuosl.org/RPM-GPG-KEY-EPEL-#{node['platform_version'].to_i}"
      options({ exclude: new_resource.exclude.join(' ') }) unless new_resource.exclude.empty?
      enabled new_resource.epel_enabled
    end
  end
end
