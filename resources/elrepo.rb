resource_name :osl_repos_elrepo
provides :osl_repos_elrepo
unified_mode true

default_action :add

# This property indicates whether the elrepo repo should be enabled
property :elrepo, [true, false], default: true
property :exclude, Array, default: []

# This is the default and only action, It will add all available repos, unless specified in properties above
action :add do
  # Initialize run state attributes
  node.run_state['elrepo'] ||= {}
  node.run_state['elrepo']['mirrorlist'] ||= {}
  node.run_state['elrepo']['baseurl'] ||= {}

  node.run_state['elrepo']['mirrorlist'] = nil
  node.run_state['elrepo']['baseurl'] = 'https://ftp.osuosl.org/pub/elrepo/elrepo/el$releasever/$basearch/'
  node.run_state['elrepo']['exclude'] = new_resource.exclude.join(' ') unless new_resource.exclude.empty?

  node.default['yum']['elrepo']['managed'] = true

  # Determine if elrepo is enabled
  node.run_state['elrepo']['enabled'] = new_resource.elrepo

  # Include the yum-elrepo recipe, which will install the elrepo repository and apply our configuration
  # Note: the elrepo repository is only availible for x86_64
  if new_resource.elrepo && platform_family?('rhel') && node['kernel']['machine'] == 'x86_64'
    if repo_resource_exist?('elrepo')
      # Find the resource and update each parameter we need changed
      r = resources(yum_repository: 'elrepo')
      node.run_state['elrepo'].each do |config, value|
        r.send(config.to_sym, value)
      end

      # Declare the resource with all parameters that are either used in yum-elrepo or we set in our cookbooks
      declare_resource(:yum_repository, 'elrepo') do
        yum_repo_parameters.each do |p|
          send(p.to_sym, r.send(p.to_sym))
        end
      end
    else
      # Copy all run state attributes to global node.default realm
      node.run_state['elrepo'].each do |config, value|
        node.default['yum']['elrepo'][config] = value
      end

      include_recipe 'yum-elrepo'
    end
  end
end
