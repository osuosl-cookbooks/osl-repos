resource_name :osl_repos_centos
provides :osl_repos_centos

default_action :add

property :appstream, [true, false], default: true
property :base, [true, false], default: true
property :elrepo, [true, false], default: true
property :epel, [true, false], default: true
property :extras, [true, false], default: true
property :main, [true, false], default: true
property :powertools, [true, false], default: true
property :updates, [true, false], default: true

property :appstream_enabled, [true, false], default: true
property :base_enabled, [true, false], default: true
property :elrepo_enabled, [true, false], default: true
property :epel_enabled, [true, false], default: true
property :extras_enabled, [true, false], default: true
property :main_enabled, [true, false], default: true
property :powertools_enabled, [true, false], default: true
property :updates_enabled, [true, false], default: true

action :add do
  node.default['yum']['main']['installonly_limit'] = '2'
  node.default['yum']['main']['installonlypkgs'] = 'kernel kernel-osuosl'
  node.default['yum']['base']['mirrorlist'] = nil
  node.default['yum']['updates']['mirrorlist'] = nil
  node.default['yum']['appstream']['mirrorlist'] = nil
  node.default['yum']['extras']['mirrorlist'] = nil
  node.default['yum']['powertools']['mirrorlist'] = nil
  node.default['yum']['epel']['mirrorlist'] = nil
  node.default['yum']['elrepo']['mirrorlist'] = nil

  case node['platform_version'].to_i
  when 7
    node.default['yum']['base']['baseurl'] = "#{centos_url}/$releasever/os/#{base_arch}/"
    node.default['yum']['updates']['baseurl'] = "#{centos_url}/$releasever/updates/#{base_arch}/"
    node.default['yum']['extras']['baseurl'] = "#{centos_url}/$releasever/extras/#{base_arch}/"
    node.default['yum']['epel']['baseurl'] = "http://epel.osuosl.org/#{node['platform_version'].to_i}/$basearch"
    %w(base updates extras).each do |r|
      node.default['yum'][r]['gpgkey'] =
        if node['kernel']['machine'] == 'x86_64'
          'file:///etc/pki/rpm-gpg/RPM-GPG-KEY-CentOS-7'
        else
          'file:///etc/pki/rpm-gpg/RPM-GPG-KEY-CentOS-7 ' \
          'file:///etc/pki/rpm-gpg/RPM-GPG-KEY-CentOS-SIG-AltArch-7-$basearch'
        end
    end
  when 8
    node.default['yum']['base']['baseurl'] = "#{centos_url}/$releasever/BaseOS/#{base_arch}/os"
    node.default['yum']['appstream']['baseurl'] = "#{centos_url}/$releasever/AppStream/#{base_arch}/os"
    node.default['yum']['extras']['baseurl'] = "#{centos_url}/$releasever/extras/#{base_arch}/os"
    node.default['yum']['powertools']['baseurl'] = "#{centos_url}/$releasever/PowerTools/#{base_arch}/os"
    node.default['yum']['epel']['baseurl'] = "http://epel.osuosl.org/#{node['platform_version'].to_i}/Everything/$basearch/"

    node.default['yum']['appstream']['enabled'] = new_resource.appstream_enabled
    node.default['yum']['powertools']['enabled'] = new_resource.powertools_enabled

    node.default['yum']['appstream']['managed'] = new_resource.appstream
    node.default['yum']['powertools']['managed'] = new_resource.powertools

    if new_resource.elrepo
      node.default['yum']['elrepo']['baseurl'] =
        "http://ftp.osuosl.org/pub/elrepo/elrepo/el#{node['platform_version'].to_i}/$basearch/"
      node.default['yum']['epel']['gpgkey'] = "http://epel.osuosl.org/RPM-GPG-KEY-EPEL-#{node['platform_version'].to_i}"

      node.default['yum']['elrepo']['enabled'] = new_resource.elrepo_enabled

      if platform?('centos') && node['kernel']['machine'] == 'x86_64'
        include_recipe 'yum-elrepo'
      end
    end
  end

  node.default['yum']['epel']['gpgkey'] = "http://epel.osuosl.org/RPM-GPG-KEY-EPEL-#{node['platform_version'].to_i}"

  node.default['yum']['base']['enabled'] = new_resource.base_enabled
  node.default['yum']['updates']['enabled'] = new_resource.updates_enabled
  node.default['yum']['epel']['enabled'] = new_resource.epel_enabled
  node.default['yum']['extras']['enabled'] = new_resource.extras_enabled

  node.default['yum']['base']['managed'] = new_resource.base
  node.default['yum']['updates']['managed'] = new_resource.updates
  node.default['yum']['epel']['managed'] = new_resource.epel
  node.default['yum']['extras']['managed'] = new_resource.extras

  include_recipe 'yum'
  include_recipe 'yum-epel'
  include_recipe 'yum-centos'
end
