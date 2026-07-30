resource_name :osl_repos_elrepo
provides :osl_repos_elrepo
unified_mode true

default_action :add

# This property indicates whether the elrepo repo should be enabled
property :elrepo, [true, false], default: true
property :exclude, Array, default: []

action_class do
  include YumElRepo::Cookbook::Helpers
end

# This is the default and only action, It will add all available repos, unless specified in properties above
action :add do
  # NOTE: the elrepo repository is only availible for x86_64
  if new_resource.elrepo && platform_family?('rhel') && node['kernel']['machine'] == 'x86_64'
    validate_yum_elrepo_platform!

    # yum-elrepo 3.0 is a resource only cookbook
    # yum_elrepo wraps Chef's built in yum_repository resource directly
    yum_repository 'elrepo' do
      description yum_elrepo_description('Community Enterprise Linux')
      baseurl 'https://ftp.osuosl.org/pub/elrepo/elrepo/el$releasever/$basearch/'
      mirrorlist nil
      gpgkey yum_elrepo_gpgkey
      exclude new_resource.exclude.join(' ') unless new_resource.exclude.empty?
      enabled new_resource.elrepo
      action :create
    end
  end
end
