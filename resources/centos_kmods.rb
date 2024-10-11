resource_name :osl_repos_centos_kmods
provides :osl_repos_centos_kmods
default_action :add
unified_mode true

property :kernel_latest, [true, false], default: false
property :kernel_6_1, [true, false], default: false
property :kernel_6_6, [true, false], default: false
property :packages_main, [true, false], default: true
property :packages_rebuild, [true, false], default: false
property :packages_userspace, [true, false], default: false

action :add do
  raise 'CentOS Kmods repositories are for RHEL systems only' unless platform_family?('rhel')

  yum_repository 'centos-kmods' do
    description 'CentOS $releasever - Kmods'
    baseurl 'https://centos-stream.osuosl.org/SIGs/$releasever/kmods/$basearch/packages-main/'
    gpgkey 'https://www.centos.org/keys/RPM-GPG-KEY-CentOS-SIG-Kmods'
  end if new_resource.packages_main

  yum_repository 'centos-kmods-rebuild' do
    description 'CentOS $releasever - Kmods - Rebuild'
    baseurl 'https://centos-stream.osuosl.org/SIGs/$releasever/kmods/$basearch/packages-rebuild/'
    gpgkey 'https://www.centos.org/keys/RPM-GPG-KEY-CentOS-SIG-Kmods'
  end if new_resource.packages_rebuild

  yum_repository 'centos-kmods-userspace' do
    description 'CentOS $releasever - Kmods - User Space'
    baseurl 'https://centos-stream.osuosl.org/SIGs/$releasever/kmods/$basearch/packages-userspace/'
    gpgkey 'https://www.centos.org/keys/RPM-GPG-KEY-CentOS-SIG-Kmods'
  end if new_resource.packages_userspace

  yum_repository 'centos-kmods-kernel-latest' do
    description 'CentOS $releasever - Kmods - Kernel'
    baseurl 'https://centos-stream.osuosl.org/SIGs/$releasever/kmods/$basearch/kernel-latest/'
    gpgkey 'https://www.centos.org/keys/RPM-GPG-KEY-CentOS-SIG-Kmods'
  end if new_resource.kernel_latest && node['platform_version'].to_i >= 9

  yum_repository 'centos-kmods-kernel-6.1' do
    description 'CentOS $releasever - Kmods - Kernel - 6.1'
    baseurl 'https://centos-stream.osuosl.org/SIGs/$releasever/kmods/$basearch/kernel-6.1/'
    gpgkey 'https://www.centos.org/keys/RPM-GPG-KEY-CentOS-SIG-Kmods'
  end if new_resource.kernel_6_1

  yum_repository 'centos-kmods-kernel-6.6' do
    description 'CentOS $releasever - Kmods - Kernel - 6.6'
    baseurl 'https://centos-stream.osuosl.org/SIGs/$releasever/kmods/$basearch/kernel-6.6/'
    gpgkey 'https://www.centos.org/keys/RPM-GPG-KEY-CentOS-SIG-Kmods'
  end if new_resource.kernel_6_6
end
