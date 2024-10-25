resource_name :osl_repos_alma
provides :osl_repos_alma
unified_mode true

default_action :add

# These properties indicate whether or not a repo should be enabled
property :base, [true, false], default: true
property :extras, [true, false], default: true
property :appstream, [true, false], default: true
property :powertools, [true, false], default: true
property :highavailability, [true, false], default: false
property :synergy, [true, false], default: false
property :exclude, Array, default: []

action :add do
  raise 'AlmaLinux repositories are for AlmaLinux systems only' unless platform?('almalinux')

  # Manage components of the main yum configuration file.
  yum_globalconfig '/etc/yum.conf' do
    cachedir '/var/cache/dnf'
    installonly_limit '2'
    installonlypkgs 'kernel kernel-osuosl'
    clean_requirements_on_remove true
  end

  passthrough = {
    'exclude' => (new_resource.exclude.join(' ') unless new_resource.exclude.empty?),
  }.compact

  yum_alma_baseos 'default' do
    mirrorlist nil
    baseurl "#{alma_url}/#{release_var}/BaseOS/$basearch/os/"
    extra_options passthrough
    enabled new_resource.base
  end

  yum_alma_appstream 'default' do
    mirrorlist nil
    baseurl "#{alma_url}/#{release_var}/AppStream/$basearch/os/"
    extra_options passthrough
    enabled new_resource.appstream
  end

  yum_alma_extras 'default' do
    mirrorlist nil
    baseurl "#{alma_url}/#{release_var}/extras/$basearch/os/"
    extra_options passthrough
    enabled new_resource.extras
  end

  yum_alma_powertools 'default' do
    mirrorlist nil
    baseurl "#{alma_url}/#{release_var}/#{osl_repo_powertools_repo_name}/$basearch/os/"
    extra_options passthrough
    enabled new_resource.powertools
  end

  yum_alma_ha 'default' do
    mirrorlist nil
    baseurl "#{alma_url}/#{release_var}/HighAvailability/$basearch/os/"
    extra_options passthrough
    enabled new_resource.highavailability
  end

  yum_alma_synergy 'default' do
    mirrorlist nil
    baseurl "#{alma_url}/#{release_var}/synergy/$basearch/os/"
    extra_options passthrough
    enabled new_resource.synergy
  end
end
