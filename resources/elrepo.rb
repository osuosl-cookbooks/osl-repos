resource_name :osl_repos_elrepo
provides :osl_repos_elrepo
unified_mode true

default_action :add

# Whether the elrepo repo is managed
property :elrepo, [true, false], default: true
property :exclude, Array, default: []

action_class do
  include YumElRepo::Cookbook::Helpers
end

# Merged with every other osl_repos_elrepo in the run, see merge_shared_config
def merged_config
  merge_shared_config(union: { exclude: exclude })
end

# Seed at compile time so the first declaration to converge sees all the others
def after_created
  merged_config
end

# The default and only action
action :add do
  # elrepo only ships x86_64, and the predicate covers the platforms its helpers raise on
  if new_resource.elrepo && yum_elrepo_supported_platform? && node['kernel']['machine'] == 'x86_64'
    # Re-merge to pick up edit_resource changes
    config = new_resource.merged_config

    # Not yum_elrepo: its mirrorlist is a non-nilable String, so `mirrorlist nil` reads as
    # a get and the elrepo.org mirrorlist would survive alongside our baseurl
    yum_repository 'elrepo' do
      description yum_elrepo_description('Community Enterprise Linux')
      baseurl 'https://ftp.osuosl.org/pub/elrepo/elrepo/el$releasever/$basearch/'
      mirrorlist nil
      gpgkey yum_elrepo_gpgkey
      exclude config[:exclude].join(' ') unless config[:exclude].empty?
    end
  end
end
