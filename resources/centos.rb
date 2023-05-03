resource_name :osl_repos_centos
provides :osl_repos_centos
unified_mode true

default_action :add

# These properties indicate whether or not a repo should be enabled
property :base, [true, false], default: true
property :extras, [true, false], default: true
property :updates, [true, false], default: true
property :exclude, Array, default: []

# This is the default and only action it will manage all repos listed above and enable them as indicated
action :add do
  raise 'CentOS repositories are for CentOS systems only' unless platform?('centos')

  # Manage components of the main yum configuration file.
  yum_globalconfig '/etc/yum.conf' do
    distroverpkg 'centos-release'
    installonly_limit '2'
    installonlypkgs 'kernel kernel-osuosl'
    clean_requirements_on_remove true
  end

  # Initialize run state attributes
  node.run_state['centos'] ||= {}
  node.run_state['centos']['base'] ||= {}
  node.run_state['centos']['extras'] ||= {}
  node.run_state['centos']['updates'] ||= {}

  # Initialize all repo mirrorlists to nil
  node.run_state['centos']['base']['mirrorlist'] = nil
  node.run_state['centos']['extras']['mirrorlist'] = nil
  node.run_state['centos']['updates']['mirrorlist'] = nil

  node.run_state['centos']['base']['baseurl'] = "#{centos_url}/$releasever/os/#{base_arch}/"
  node.run_state['centos']['updates']['baseurl'] = "#{centos_url}/$releasever/updates/#{base_arch}/"
  node.run_state['centos']['extras']['baseurl'] = "#{centos_url}/$releasever/extras/#{base_arch}/"

  # Set the gpg key for each repo
  # This ensures that the AltArch gpg key is included in any non x86_64 architecture
  %w(base updates extras).each do |r|
    node.run_state['centos'][r]['gpgkey'] = centos_7_gpgkey
    node.run_state['centos'][r]['exclude'] = new_resource.exclude.join(' ') unless new_resource.exclude.empty?
  end

  # Determine if the base, extras, and updates repositories are enabled
  node.run_state['centos']['base']['enabled'] = new_resource.base
  node.run_state['centos']['extras']['enabled'] = new_resource.extras
  node.run_state['centos']['updates']['enabled'] = new_resource.updates

  node.default['yum']['base']['managed'] = true
  node.default['yum']['extras']['managed'] = true
  node.default['yum']['updates']['managed'] = true

  if repo_resource_exist?('base')
    node['yum-centos']['repos'].each do |repo|
      # Find the resource and update each parameter we need changed
      next unless node['yum'][repo]['managed']
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
