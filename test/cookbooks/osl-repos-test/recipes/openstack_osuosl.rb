osl_repos_openstack 'default' do
  source :osuosl
end

# A staged next release: written, but never enabled or fetched
osl_repos_openstack 'zed' do
  source :osuosl
  version 'zed'
  repo_name 'OSL-openstack-zed'
  enabled false
end

# Smoke-test the repo; only el9/x86_64 RPMs are published so far
package 'osuosl-openstack-keystone' if node['platform_version'].to_i == 9 && node['kernel']['machine'] == 'x86_64'
