resource_name :osl_repos_epel
provides :osl_repos_epel
unified_mode true

default_action :add

# Whether the epel repo is managed
property :epel, [true, false], default: true

# Whether the epel repo is enabled
property :epel_enabled, [true, false], default: true
property :exclude, Array, default: []

# Merged with every other osl_repos_epel in the run, see merge_shared_config
def merged_config
  merge_shared_config(
    union: { exclude: exclude },
    all: { enabled: epel && epel_enabled }
  )
end

# Seed at compile time so the first declaration to converge sees all the others
def after_created
  merged_config
end

# The default and only action
action :add do
  if platform_family?('rhel')
    # Re-merge to pick up edit_resource changes
    config = new_resource.merged_config

    # yum-epel 6.x is resource only, yum_epel_repository wraps yum_repository directly
    yum_epel_repository 'epel' do
      baseurl epel_baseurl
      mirrorlist nil
      gpgkey "https://epel.osuosl.org/RPM-GPG-KEY-EPEL-#{node['platform_version'].to_i}"
      # No exclude property, options is merged into the yum_repository config
      options({ exclude: config[:exclude].join(' ') }) unless config[:exclude].empty?
      # Written even when off, so an epel.repo from epel-release ends up disabled
      enabled config[:enabled]
    end
  end
end
