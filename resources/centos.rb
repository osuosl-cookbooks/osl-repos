resource_name :osl_repos_centos
provides :osl_repos_centos

default_action :add

# These properties indicate wether or not a repo should be enabled
property :base, [true, false], default: true
property :extras, [true, false], default: true
property :updates, [true, false], default: true

# These repositories are only availible on Centos 8
# The associated properties will be ignored on Centos 7
property :appstream, [true, false], default: true
property :powertools, [true, false], default: true

# This is the default and only action, It will add all availible repos, unless specified in properties above
action :add do
  # Set 'installonly_limit' and 'installonlypkgs' in the main yum configuration file.
  node.default['yum']['main']['installonly_limit'] = '2'
  node.default['yum']['main']['installonlypkgs'] = 'kernel kernel-osuosl'

  # Initialize all repo mirrorlists to nil
  # Note: any changes made here and throught the recipe will not apply if the corresponding repository is unmanaged
  node.default['yum']['appstream']['mirrorlist'] = nil
  node.default['yum']['base']['mirrorlist'] = nil
  node.default['yum']['extras']['mirrorlist'] = nil
  node.default['yum']['powertools']['mirrorlist'] = nil
  node.default['yum']['updates']['mirrorlist'] = nil

  # As mentioned above C7 and C8 have different availible repos and options
  case node['platform_version'].to_i

  ####### Begin Centos 7 case #######
  when 7

    # Update the base url for our Centos 7 repos (base, updates, extras, and epel)
    node.default['yum']['base']['baseurl'] = "#{centos_url}/$releasever/os/#{base_arch}/"
    node.default['yum']['updates']['baseurl'] = "#{centos_url}/$releasever/updates/#{base_arch}/"
    node.default['yum']['extras']['baseurl'] = "#{centos_url}/$releasever/extras/#{base_arch}/"

    # Set the gpg key for each repo (excluding epel)
    # This case ensures that the AltArch gpg key is included in any non x86_64 architecture
    %w(base updates extras).each do |r|
      node.default['yum'][r]['gpgkey'] =
        if node['kernel']['machine'] == 'x86_64'
          'file:///etc/pki/rpm-gpg/RPM-GPG-KEY-CentOS-7'
        else
          'file:///etc/pki/rpm-gpg/RPM-GPG-KEY-CentOS-7 file:///etc/pki/rpm-gpg/RPM-GPG-KEY-CentOS-SIG-AltArch-7-$basearch'
        end
    end

    # Updates is only installed on Centos 7
    # Determine if updates repo is managed
    node.default['yum']['updates']['managed'] = true
    # Determine if updates repo is enabled
    node.default['yum']['updates']['enabled'] = new_resource.updates

  ####### Begin Centos 8 case #######
  when 8

    # Update the base url for our Centos 8 repos (appstream, base, epel, extras, and powertools)
    node.default['yum']['appstream']['baseurl'] = "#{centos_url}/$releasever/AppStream/#{base_arch}/os"
    node.default['yum']['base']['baseurl'] = "#{centos_url}/$releasever/BaseOS/#{base_arch}/os"
    node.default['yum']['extras']['baseurl'] = "#{centos_url}/$releasever/extras/#{base_arch}/os"
    node.default['yum']['powertools']['baseurl'] = "#{centos_url}/$releasever/PowerTools/#{base_arch}/os"

    # Powertools and appstream are only availible for Centos 8 so we set their properties here
    # Determine if powertools and appstream are managed
    node.default['yum']['appstream']['managed'] = true
    node.default['yum']['powertools']['managed'] = true

    # Determine if powertools and appstream are enabled
    node.default['yum']['appstream']['enabled'] = new_resource.appstream
    node.default['yum']['powertools']['enabled'] = new_resource.powertools

  end ####### End of switchcase #######

  # These repositories are used by Centos 7 and Centos 8, so we set their state outside of the switchcase

  # Determine if the base, epel, and extras repositories are managed
  node.default['yum']['base']['managed'] = true
  node.default['yum']['extras']['managed'] = true

  # Determine if the base, epel, and extras repositories are enabled
  node.default['yum']['base']['enabled'] = new_resource.base
  node.default['yum']['extras']['enabled'] = new_resource.extras

  # Include 'yum', and 'yum-centos' recipies
  # 'yum' will apply our changes to the main config file
  # 'yum-centos' install the remaining repositories and apply our configuration
  include_recipe 'yum'
  include_recipe 'yum-centos'
end
