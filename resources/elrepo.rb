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

# The default and only action
action :add do
  # elrepo only ships x86_64, and the predicate covers the platforms its helpers raise on
  if new_resource.elrepo && yum_elrepo_supported_platform? && node['kernel']['machine'] == 'x86_64'
    # Not yum_elrepo: its mirrorlist is a non-nilable String, so `mirrorlist nil` reads as
    # a get and the elrepo.org mirrorlist would survive alongside our baseurl
    yum_repository 'elrepo' do
      description yum_elrepo_description('Community Enterprise Linux')
      baseurl 'https://ftp.osuosl.org/pub/elrepo/elrepo/el$releasever/$basearch/'
      mirrorlist nil
      gpgkey yum_elrepo_gpgkey
      exclude new_resource.exclude.join(' ') unless new_resource.exclude.empty?
    end
  end
end
