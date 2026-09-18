resource_name :osl_repos_centos_kmods
provides :osl_repos_centos_kmods
default_action :add
unified_mode true

# Kernel stream from the Kmods SIG (https://sigs.centos.org/kmods/repositories/);
# nil leaves the stock kernel alone
property :kernel, String, equal_to: %w(6.1 6.6 6.12 6.18 latest)
property :packages_main, [true, false], default: true
property :packages_rebuild, [true, false], default: false
property :packages_userspace, [true, false], default: false

action :add do
  raise 'CentOS Kmods repositories are for RHEL systems only' unless platform_family?('rhel')

  kmods_url = 'https://centos-stream.osuosl.org/SIGs/$releasever/kmods/$basearch'
  kmods_gpgkey = 'https://www.centos.org/keys/RPM-GPG-KEY-CentOS-SIG-Kmods'

  [
    ['centos-kmods', 'CentOS $releasever - Kmods', 'packages-main', new_resource.packages_main],
    ['centos-kmods-rebuild', 'CentOS $releasever - Kmods - Rebuild', 'packages-rebuild', new_resource.packages_rebuild],
    ['centos-kmods-userspace', 'CentOS $releasever - Kmods - User Space', 'packages-userspace', new_resource.packages_userspace],
  ].each do |repo, desc, path, enabled|
    next unless enabled

    yum_repository repo do
      description desc
      baseurl "#{kmods_url}/#{path}/"
      gpgkey kmods_gpgkey
    end
  end

  if new_resource.kernel
    release = node['platform_version'].to_i
    streams = kmods_kernel_streams.fetch(release, [])
    unless streams.include?(new_resource.kernel)
      raise "CentOS Kmods does not publish kernel-#{new_resource.kernel} for EL#{release} " \
            "(available: #{streams.join(', ')})"
    end

    yum_repository "centos-kmods-kernel-#{new_resource.kernel}" do
      description "CentOS $releasever - Kmods - Kernel - #{new_resource.kernel}"
      baseurl "#{kmods_url}/kernel-#{new_resource.kernel}/"
      gpgkey kmods_gpgkey
      # Keep AlmaLinux's kernel-headers for glibc, as the SIG's own repo file does
      exclude 'kernel-headers kernel-cross-headers'
    end
  end
end
