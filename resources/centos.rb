resource_name :osl_repos_centos
provides :osl_repos_centos

default_action :add

# These properties indicate wether or not a repo should be managed
# If unmanaged the repo file will not be created or changed
property :base, [true, false], default: true
property :epel, [true, false], default: true
property :extras, [true, false], default: true
property :updates, [true, false], default: true

# These repositories are only availible on Centos 8
# The associated properties will be ignored on Centos 7
property :appstream, [true, false], default: true
property :elrepo, [true, false], default: true
property :powertools, [true, false], default: true

# These properties indicate wether or not a repo should be enabled
# Note: If unmanaged is set the repo's enabled/disabled state will not be changed
property :base_enabled, [true, false], default: true
property :epel_enabled, [true, false], default: true
property :extras_enabled, [true, false], default: true
property :updates_enabled, [true, false], default: true

# These repositories are only availible on Centos 8
# The associated properties will be ignored on Centos 7
property :appstream_enabled, [true, false], default: true
property :elrepo_enabled, [true, false], default: true
property :powertools_enabled, [true, false], default: true

# This is the default and only action, It will add all availible repos, unless specified in properties above
action :add do
  # Set 'installonly_limit' and 'installonlypkgs' in the main yum configuration file.
  node.default['yum']['main']['installonly_limit'] = '2'
  node.default['yum']['main']['installonlypkgs'] = 'kernel kernel-osuosl'

  # Initialize all repo mirrorlists to nil
  # Note: any changes made here and throught the recipe will not apply if the corresponding repository is unmanaged
  node.default['yum']['base']['mirrorlist'] = nil
  node.default['yum']['updates']['mirrorlist'] = nil
  node.default['yum']['appstream']['mirrorlist'] = nil
  node.default['yum']['extras']['mirrorlist'] = nil
  node.default['yum']['powertools']['mirrorlist'] = nil
  node.default['yum']['epel']['mirrorlist'] = nil
  node.default['yum']['elrepo']['mirrorlist'] = nil

  # As mentioned above C7 and C8 have different availible repos and options
  case node['platform_version'].to_i

  ####### Begin Centos 7 case #######
  when 7

    # Update the base url for our Centos 7 repos (base, updates, extras, and epel)
    node.default['yum']['base']['baseurl'] = "#{centos_url}/$releasever/os/#{base_arch}/"
    node.default['yum']['updates']['baseurl'] = "#{centos_url}/$releasever/updates/#{base_arch}/"
    node.default['yum']['extras']['baseurl'] = "#{centos_url}/$releasever/extras/#{base_arch}/"
    node.default['yum']['epel']['baseurl'] = "http://epel.osuosl.org/#{node['platform_version'].to_i}/$basearch"

    # Set the gpg key for each repo (excluding epel)
    # This case ensures that the AltArch gpg key is included in any non x86_64 architecture
    %w(base updates extras).each do |r|
      node.default['yum'][r]['gpgkey'] =
        if node['kernel']['machine'] == 'x86_64'
          'file:///etc/pki/rpm-gpg/RPM-GPG-KEY-CentOS-7'
        else
          'file:///etc/pki/rpm-gpg/RPM-GPG-KEY-CentOS-7 ' \
          'file:///etc/pki/rpm-gpg/RPM-GPG-KEY-CentOS-SIG-AltArch-7-$basearch'
        end
    end

    # Updates is only installed on Centos 7
    # Determine if updates repo is managed
    node.default['yum']['updates']['managed'] = new_resource.updates

    # Determine if updates repo is enabled
    node.default['yum']['updates']['enabled'] = new_resource.updates_enabled

  ####### Begin Centos 8 case #######
  when 8

    # Update the base url for our Centos 8 repos (appstream, base, epel, extras, and powertools)
    node.default['yum']['appstream']['baseurl'] = "#{centos_url}/$releasever/AppStream/#{base_arch}/os"
    node.default['yum']['base']['baseurl'] = "#{centos_url}/$releasever/BaseOS/#{base_arch}/os"
    node.default['yum']['epel']['baseurl'] = "http://epel.osuosl.org/#{node['platform_version'].to_i}/Everything/$basearch/"
    node.default['yum']['extras']['baseurl'] = "#{centos_url}/$releasever/extras/#{base_arch}/os"
    node.default['yum']['powertools']['baseurl'] = "#{centos_url}/$releasever/PowerTools/#{base_arch}/os"

    # Powertools and appstream are only availible for Centos 8 so we set their properties here
    # Determine if powertools and appstream are managed
    node.default['yum']['appstream']['managed'] = new_resource.appstream
    node.default['yum']['powertools']['managed'] = new_resource.powertools

    # Determine if powertools and appstream are enabled
    node.default['yum']['appstream']['enabled'] = new_resource.appstream_enabled
    node.default['yum']['powertools']['enabled'] = new_resource.powertools_enabled

    # If elrepo is managed, and the machine is running centos on the x86_64 architecture install elrepo
    if new_resource.elrepo && platform?('centos') && node['kernel']['machine'] == 'x86_64'

      # Set the base url
      node.default['yum']['elrepo']['baseurl'] =
        "http://ftp.osuosl.org/pub/elrepo/elrepo/el#{node['platform_version'].to_i}/$basearch/"

      # Determine if elrepo is enabled
      node.default['yum']['elrepo']['enabled'] = new_resource.elrepo_enabled

      # Include the yum-elrepo recipe, which will install the elrepo repository and apply our configuration
      include_recipe 'yum-elrepo'
    end

  end ####### End of switchcase #######

  # Set the epel gpg key, this is outside the switchcase as it is the same format on both platforms
  node.default['yum']['epel']['gpgkey'] = "http://epel.osuosl.org/RPM-GPG-KEY-EPEL-#{node['platform_version'].to_i}"

  # These repositories are used by Centos 7 and Centos 8, so we set their state outside of the switchcase

  # Determine if the base, epel, and extras repositories are managed
  node.default['yum']['base']['managed'] = new_resource.base
  node.default['yum']['epel']['managed'] = new_resource.epel
  node.default['yum']['extras']['managed'] = new_resource.extras

  # Determine if the base, epel, and extras repositories are enabled
  node.default['yum']['base']['enabled'] = new_resource.base_enabled
  node.default['yum']['epel']['enabled'] = new_resource.epel_enabled
  node.default['yum']['extras']['enabled'] = new_resource.extras_enabled

  # Include 'yum', 'yum-epel', and 'yum-centos' recipies
  # 'yum' will apply our changes to the main config file
  # 'yum-epel' will install the epel repository and apply our configuration
  # 'yum-centos' install the remaining repositories and apply our configuration
  include_recipe 'yum'
  include_recipe 'yum-epel'
  include_recipe 'yum-centos'
end
