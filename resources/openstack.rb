resource_name :osl_repos_openstack
provides :osl_repos_openstack
unified_mode true

default_action :add

property :version, String, default: lazy { openstack_release }

action :add do
  include_recipe 'osl-repos::epel'

  yum_repository 'RDO-openstack' do
    description "OpenStack RDO #{new_resource.version}"
    baseurl "#{openstack_baseurl}/$basearch/openstack-#{new_resource.version}"
    gpgkey 'https://www.centos.org/keys/RPM-GPG-KEY-CentOS-SIG-Cloud'
    priority '20'
    options(module_hotfixes: '1')
  end

  yum_repository 'OSL-openstack' do
    description "OpenStack OSL #{new_resource.version}"
    baseurl "https://ftp.osuosl.org/pub/osl/repos/yum/$releasever/openstack-#{new_resource.version}/$basearch"
    gpgkey osl_gpg_key
    priority '10'
  end

  # NOTE: Only needed on POWER10
  yum_repository 'OSL-openstack-power10' do
    description "OpenStack OSL #{new_resource.version} - POWER10"
    baseurl "https://ftp.osuosl.org/pub/osl/repos/yum/$releasever/openstack-#{new_resource.version}-power10/$basearch"
    gpgkey osl_gpg_key
    priority '10'
    options(module_hotfixes: '1')
  end if node.read('cpu', 'model_name').to_s.match?(/POWER10/)

  yum_repository 'centos-nfv' do
    description 'CentOS $releasever - NFV'
    baseurl openstack_nfv_baseurl
    gpgkey 'https://centos.org/keys/RPM-GPG-KEY-CentOS-SIG-NFV'
  end
end
