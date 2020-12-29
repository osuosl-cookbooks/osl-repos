resource_name :osl_repos_elrepo
provides :osl_repos_elrepo

### Note: the elrepo repository is only availible on centos 8, using this resource on centos 7 will produce no results

default_action :add

# This property indicates wether the elrepo repo should be managed
# If unmanaged the repo file will not be created or changed
property :elrepo, [true, false], default: true

# This property indicates wether or not the elrepo repo should be enabled
# Note: If unmanaged is set the repo's enabled/disabled state will not be changed
property :elrepo_enabled, [true, false], default: true

# This is the default and only action, It will add all availible repos, unless specified in properties above
action :add do
  # Install the repo only on Centos 8
  if node['platform_version'].to_i >= 8
    # Initialize repo mirrorlists to nil
    # Note: any changes made here and throught the recipe will not apply if the repository is unmanaged
    node.default['yum']['elrepo']['mirrorlist'] = nil

    # Set the base url
    node.default['yum']['elrepo']['baseurl'] =
    "http://ftp.osuosl.org/pub/elrepo/elrepo/el#{node['platform_version'].to_i}/$basearch/"

    # Determine if elrepo is enabled
    node.default['yum']['elrepo']['enabled'] = new_resource.elrepo_enabled
    node.default['yum']['elrepo']['managed'] = new_resource.elrepo_enabled

    # If elrepo is managed, and the machine is running centos on the x86_64 architecture
    # Include the yum-elrepo recipe, which will install the elrepo repository and apply our configuration
    if new_resource.elrepo && platform?('centos') && node['kernel']['machine'] == 'x86_64'
      include_recipe 'yum-elrepo'
    end

  end
end
