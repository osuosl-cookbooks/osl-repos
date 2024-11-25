osl_repos_alma 'defualt' do
  powertools true
end if node['platform_version'].to_i <= 8

osl_repos_openstack 'default'

package %w(python3-openstackclient openstack-neutron)
