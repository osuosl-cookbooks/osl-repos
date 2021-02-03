resource_name :osl_repos_centos
provides :osl_repos_centos

default_action :add

# These properties indicate whether or not a repo should be enabled
# appstream, highavailability, and powertools are only available on centos 8
# updates is only available on centos 7
# if a repo is not supported for the target os it's options will simply be ignored
property :base, [true, false], default: true
property :extras, [true, false], default: true
property :updates, [true, false], default: true
property :appstream, [true, false], default: true
property :powertools, [true, false], default: true
property :highavailability, [true, false], default: false

# This is the default and only action it will manage all repos listed above and enable them as indicated
action :add do
  # Manage components of the main yum configuration file.
  node.default['yum']['main']['installonly_limit'] = '2'
  node.default['yum']['main']['installonlypkgs'] = 'kernel kernel-osuosl'

  # Initialize all repo mirrorlists to nil
  node.default['yum']['appstream']['mirrorlist'] = nil
  node.default['yum']['base']['mirrorlist'] = nil
  node.default['yum']['extras']['mirrorlist'] = nil
  node.default['yum']['powertools']['mirrorlist'] = nil
  node.default['yum']['updates']['mirrorlist'] = nil
  node.default['yum']['highavailability']['mirrorlist'] = nil

  case node['platform_version'].to_i
  when 7

    node.default['yum']['base']['baseurl'] = "#{centos_url}/$releasever/os/#{base_arch}/"
    node.default['yum']['updates']['baseurl'] = "#{centos_url}/$releasever/updates/#{base_arch}/"
    node.default['yum']['extras']['baseurl'] = "#{centos_url}/$releasever/extras/#{base_arch}/"

    # Set the gpg key for each repo
    # This ensures that the AltArch gpg key is included in any non x86_64 architecture
    %w(base updates extras).each do |r|
      node.default['yum'][r]['gpgkey'] = centos_7_gpgkey
    end

    # Updates is only installed on Centos 7
    node.default['yum']['updates']['managed'] = true

    # Determine if updates repo is enabled
    node.default['yum']['updates']['enabled'] = new_resource.updates

  when 8

    node.default['yum']['appstream']['baseurl'] = "#{centos_url}/$releasever/AppStream/#{base_arch}/os/"
    node.default['yum']['base']['baseurl'] = "#{centos_url}/$releasever/BaseOS/#{base_arch}/os/"
    node.default['yum']['extras']['baseurl'] = "#{centos_url}/$releasever/extras/#{base_arch}/os/"
    node.default['yum']['highavailability']['baseurl'] = "#{centos_url}/$releasever/HighAvailability/#{base_arch}/os/"
    node.default['yum']['powertools']['baseurl'] = "#{centos_url}/$releasever/PowerTools/#{base_arch}/os/"

    # appstream, highavailibility, and powertools are only available for Centos 8 so we set their properties here
    node.default['yum']['appstream']['managed'] = true
    node.default['yum']['highavailability']['managed'] = true
    node.default['yum']['powertools']['managed'] = true

    # Determine if appstream, highavailibility, and powertools are enabled
    node.default['yum']['appstream']['enabled'] = new_resource.appstream
    node.default['yum']['highavailability']['enabled'] = new_resource.highavailability
    node.default['yum']['powertools']['enabled'] = new_resource.powertools

  end

  # These repositories are used by both Centos 7 and Centos 8, so we set their state outside of the switchcase
  node.default['yum']['base']['managed'] = true
  node.default['yum']['extras']['managed'] = true

  # Determine if the base, epel, and extras repositories are enabled
  node.default['yum']['base']['enabled'] = new_resource.base
  node.default['yum']['extras']['enabled'] = new_resource.extras

  # Include 'yum', and 'yum-centos' recipies
  # 'yum' will apply our changes to the main config file
  # 'yum-centos' install the remaining repositories and apply our configuration
  if repo_resource_exist?('base')
    edit_resource(:yum_globalconfig, '/etc/yum.conf') do
      node['yum']['main'].each do |config, value|
        send(config.to_sym, value)
      end
    end

    node['yum-centos']['repos'].each do |repo|
      next unless node['yum'][repo]['managed']
      edit_resource(:yum_repository, repo) do
        node['yum'][repo].each do |config, value|
          case config
          when 'managed' # rubocop: disable Lint/EmptyWhen
          when 'baseurl'
            send(config.to_sym, lazy { value })
          else
            send(config.to_sym, value)
          end
        end
      end
    end
  else
    include_recipe 'yum'
    include_recipe 'yum-centos'
  end
end
