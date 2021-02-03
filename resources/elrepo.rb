resource_name :osl_repos_elrepo
provides :osl_repos_elrepo

default_action :add

# This property indicates whether the elrepo repo should be enabled
property :elrepo, [true, false], default: true

# This is the default and only action, It will add all available repos, unless specified in properties above
action :add do
  node.default['yum']['elrepo']['mirrorlist'] = nil
  node.default['yum']['elrepo']['baseurl'] = 'https://ftp.osuosl.org/pub/elrepo/elrepo/el$releasever/$basearch/'
  node.default['yum']['elrepo']['managed'] = true

  # Determine if elrepo is enabled
  node.default['yum']['elrepo']['enabled'] = new_resource.elrepo

  # Include the yum-elrepo recipe, which will install the elrepo repository and apply our configuration
  # Note: the elrepo repository is only availible for x86_64
  if new_resource.elrepo && platform?('centos') && node['kernel']['machine'] == 'x86_64'
    if repo_resource_exist?('elrepo')
      edit_resource(:yum_repository, 'elrepo') do
        node['yum']['elrepo'].each do |config, value|
          case config
          when 'managed' # rubocop: disable Lint/EmptyWhen
          when 'baseurl'
            send(config.to_sym, lazy { value })
          else
            send(config.to_sym, value)
          end
        end
      end
    else
      include_recipe 'yum-elrepo'
    end
  end
end
