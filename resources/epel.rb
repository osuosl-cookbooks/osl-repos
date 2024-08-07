resource_name :osl_repos_epel
provides :osl_repos_epel
unified_mode true

default_action :add

# This property indicates whether the epel repo should be managed
property :epel, [true, false], default: true

# This property indicates whether or not the epel repo should be enabled
property :epel_enabled, [true, false], default: true
property :exclude, Array, default: []

# This is the default and only action, It will add all available repos, unless specified in properties above
action :add do
  # Initialize run state attributes
  node.run_state['epel'] ||= {}
  node.run_state['epel']['mirrorlist'] ||= {}
  node.run_state['epel']['baseurl'] ||= {}
  node.run_state['epel']['gpgkey'] ||= {}

  node.run_state['epel']['mirrorlist'] = nil
  node.run_state['epel']['baseurl'] = epel_baseurl
  node.run_state['epel']['gpgkey'] = "https://epel.osuosl.org/RPM-GPG-KEY-EPEL-#{node['platform_version'].to_i}"
  node.run_state['epel']['exclude'] = new_resource.exclude.join(' ') unless new_resource.exclude.empty?

  # Determine if the repository is managed
  node.default['yum']['epel']['managed'] = true

  # Determine if the repository is enabled
  node.run_state['epel']['enabled'] = new_resource.epel

  # 'yum-epel' will install the epel repository and apply our configuration
  if repo_resource_exist?('epel')
    node['yum-epel']['repos'].each do |repo|
      next unless node['yum'][repo]['managed']
      # Find the resource and update each parameter we need changed
      r = resources(yum_repository: repo)
      node.run_state[repo].each do |config, value|
        r.send(config.to_sym, value)
      end

      # Declare the resource with all parameters that are either used in yum-almalinux or we set in our cookbooks
      declare_resource(:yum_repository, repo) do
        yum_repo_parameters.each do |p|
          send(p.to_sym, r.send(p.to_sym))
        end
      end
    end
  else
    # Copy all run state attributes to global node.default realm
    node['yum-epel']['repos'].each do |repo|
      next unless node['yum'][repo]['managed']
      node.run_state[repo].each do |config, value|
        node.default['yum'][repo][config] = value
      end
    end

    include_recipe 'yum-epel'
  end
end
