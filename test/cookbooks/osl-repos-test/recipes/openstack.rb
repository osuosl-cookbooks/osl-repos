osl_repos_openstack 'default'

osc_pkg = node['platform_version'].to_i == 7 ? 'python2-openstackclient' : 'python3-openstackclient'

package osc_pkg
