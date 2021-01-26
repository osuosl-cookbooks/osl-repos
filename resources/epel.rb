resource_name :osl_repos_epel
provides :osl_repos_epel

default_action :add

# This property indicates whether the epel repo should be managed
property :epel, [true, false], default: true

# This property indicates whether or not the epel repo should be enabled
property :epel_enabled, [true, false], default: true

# This is the default and only action, It will add all available repos, unless specified in properties above
action :add do
  node.default['yum']['epel']['mirrorlist'] = nil
  node.default['yum']['epel']['baseurl'] = epel_baseurl
  node.default['yum']['epel']['gpgkey'] = "https://epel.osuosl.org/RPM-GPG-KEY-EPEL-#{node['platform_version'].to_i}"

  # Determine if the repository is managed
  node.default['yum']['epel']['managed'] = true unless node['kernel']['machine'] == 's390x'

  # Determine if the repository is enabled
  node.default['yum']['epel']['enabled'] = new_resource.epel

  # 'yum-epel' will install the epel repository and apply our configuration
  include_recipe 'yum-epel'
end
