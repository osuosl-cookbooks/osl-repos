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
  yum_globalconfig '/etc/yum.conf' do
    if node['platform_version'].to_i < 8
      distroverpkg 'centos-release'
    else
      cachedir '/var/cache/dnf'
    end
    installonly_limit '2'
    installonlypkgs 'kernel kernel-osuosl'
    clean_requirements_on_remove true
  end

  # Initialize run state attributes
  node.run_state['centos'] ||= {}
  node.run_state['centos']['appstream'] ||= {}
  node.run_state['centos']['base'] ||= {}
  node.run_state['centos']['extras'] ||= {}
  node.run_state['centos']['powertools'] ||= {}
  node.run_state['centos']['updates'] ||= {}
  node.run_state['centos']['highavailability'] ||= {}

  # Initialize all repo mirrorlists to nil
  node.run_state['centos']['appstream']['mirrorlist'] = nil
  node.run_state['centos']['base']['mirrorlist'] = nil
  node.run_state['centos']['extras']['mirrorlist'] = nil
  node.run_state['centos']['powertools']['mirrorlist'] = nil
  node.run_state['centos']['updates']['mirrorlist'] = nil
  node.run_state['centos']['highavailability']['mirrorlist'] = nil

  case node['platform_version'].to_i
  when 7

    node.run_state['centos']['base']['baseurl'] = "#{centos_url}/$releasever/os/#{base_arch}/"
    node.run_state['centos']['updates']['baseurl'] = "#{centos_url}/$releasever/updates/#{base_arch}/"
    node.run_state['centos']['extras']['baseurl'] = "#{centos_url}/$releasever/extras/#{base_arch}/"

    # Set the gpg key for each repo
    # This ensures that the AltArch gpg key is included in any non x86_64 architecture
    %w(base updates extras).each do |r|
      node.run_state['centos'][r]['gpgkey'] = centos_7_gpgkey
    end

    # Updates is only installed on Centos 7
    node.default['yum']['updates']['managed'] = true

    # Determine if updates repo is enabled
    node.run_state['centos']['updates']['enabled'] = new_resource.updates

  when 8

    node.run_state['centos']['appstream']['baseurl'] = "#{centos_url}/$releasever/AppStream/#{base_arch}/os/"
    node.run_state['centos']['base']['baseurl'] = "#{centos_url}/$releasever/BaseOS/#{base_arch}/os/"
    node.run_state['centos']['extras']['baseurl'] = "#{centos_url}/$releasever/extras/#{base_arch}/os/"
    node.run_state['centos']['highavailability']['baseurl'] = "#{centos_url}/$releasever/HighAvailability/#{base_arch}/os/"
    node.run_state['centos']['powertools']['baseurl'] = "#{centos_url}/$releasever/PowerTools/#{base_arch}/os/"

    # appstream, highavailibility, and powertools are only available for Centos 8 so we set their properties here
    node.default['yum']['appstream']['managed'] = true
    node.default['yum']['highavailability']['managed'] = true
    node.default['yum']['powertools']['managed'] = true

    # Determine if appstream, highavailibility, and powertools are enabled
    node.run_state['centos']['appstream']['enabled'] = new_resource.appstream
    node.run_state['centos']['highavailability']['enabled'] = new_resource.highavailability
    node.run_state['centos']['powertools']['enabled'] = new_resource.powertools

  end

  # These repositories are used by both Centos 7 and Centos 8, so we set their state outside of the switchcase
  node.default['yum']['base']['managed'] = true
  node.default['yum']['extras']['managed'] = true

  # Determine if the base, epel, and extras repositories are enabled
  node.run_state['centos']['base']['enabled'] = new_resource.base
  node.run_state['centos']['extras']['enabled'] = new_resource.extras

  if repo_resource_exist?('base')
    node['yum-centos']['repos'].each do |repo|
      next unless node['yum'][repo]['managed']
      # Find the resource and update each parameter we need changed
      r = resources(yum_repository: repo)
      node.run_state['centos'][repo].each do |config, value|
        r.send(config.to_sym, value)
      end

      # Declare the resource with all parameters
      declare_resource(:yum_repository, repo) do
        yum_repo_parameters.each do |p|
          send(p.to_sym, r.send(p.to_sym))
        end
      end
    end
  else
    # Copy all run state attributes to global node.default realm
    node['yum-centos']['repos'].each do |repo|
      next unless node['yum'][repo]['managed']
      node.run_state['centos'][repo].each do |config, value|
        node.default['yum'][repo][config] = value
      end
    end
    include_recipe 'yum-centos'
  end
end
