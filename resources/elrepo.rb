resource_name :osl_repos_elrepo
provides :osl_repos_elrepo

default_action :add

# This property indicates whether the elrepo repo should be enabled
# If unmanaged the repo file will not be created or changed
property :elrepo, [true, false], default: true

# This is the default and only action, It will add all availible repos, unless specified in properties above
action :add do
  # NOTE: any changes made here and throught the recipe will not apply if the repository is unmanaged
  node.default['yum']['elrepo']['mirrorlist'] = nil

  # Set the base url
  node.default['yum']['elrepo']['baseurl'] = 'https://ftp.osuosl.org/pub/elrepo/elrepo/el$releasever/$basearch/'

  # Determine if elrepo is enabled
  node.default['yum']['elrepo']['enabled'] = new_resource.elrepo
  node.default['yum']['elrepo']['managed'] = true

  # If the machine is running centos on the x86_64 architecture
  # Include the yum-elrepo recipe, which will install the elrepo repository and apply our configuration
  if new_resource.elrepo && platform?('centos') && node['kernel']['machine'] == 'x86_64'
    include_recipe 'yum-elrepo'
  end
end
