resource_name :osl_repos_epel
provides :osl_repos_epel

default_action :add

# This property indicates wether the epel repo should be managed
# If unmanaged the repo file will not be created or changed
property :epel, [true, false], default: true

# This property indicates wether or not the epel repo should be enabled
# Note: If unmanaged is set the repo's enabled/disabled state will not be changed
property :epel_enabled, [true, false], default: true

# This is the default and only action, It will add all availible repos, unless specified in properties above
action :add do
  # Initialize repo mirrorlists to nil
  # Note: any changes made here and throught the recipe will not apply if the repository is unmanaged
  node.default['yum']['epel']['mirrorlist'] = nil

  # As mentioned above C7 and C8 have different availible repos and options
  case node['platform_version'].to_i

  ### Centos 7 Case ###
  when 7
    node.default['yum']['epel']['baseurl'] = "http://epel.osuosl.org/#{node['platform_version'].to_i}/$basearch"

  ### Centos 8 Case ###
  when 8
    node.default['yum']['epel']['baseurl'] = "http://epel.osuosl.org/#{node['platform_version'].to_i}/Everything/$basearch/"

  end

  # Set the epel gpg key, this is the same for both platforms
  node.default['yum']['epel']['gpgkey'] = "http://epel.osuosl.org/RPM-GPG-KEY-EPEL-#{node['platform_version'].to_i}"

  # Determine if the repository is managed
  node.default['yum']['epel']['managed'] = new_resource.epel

  # Determine if the repository is enabled
  node.default['yum']['epel']['enabled'] = new_resource.epel_enabled

  # 'yum-epel' will install the epel repository and apply our configuration
  include_recipe 'yum-epel'
end
