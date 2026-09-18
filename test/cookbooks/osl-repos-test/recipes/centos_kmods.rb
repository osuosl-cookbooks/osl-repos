osl_repos_centos_kmods 'default' do
  kernel node['platform_version'].to_i < 9 ? '6.6' : '6.18'
  packages_rebuild true
  packages_userspace true
end
