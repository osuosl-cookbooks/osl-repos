control 'openstack' do
  title 'Verify elevate yum repo is configured'

  rel = os[:release].to_i
  arch = os[:arch]

  describe yum.repo('RDO-openstack') do
    it { should exist }
    it { should be_enabled }
    case rel
    when 10
      its('baseurl') { should include "https://centos-stream.osuosl.org/SIGs/10-stream/cloud/#{arch}/openstack-epoxy" }
    when 9
      its('baseurl') { should include "https://centos-stream.osuosl.org/SIGs/9-stream/cloud/#{arch}/openstack-yoga" }
    when 8
      its('baseurl') { should include "https://ftp.osuosl.org/pub/osl/rdo/8/#{arch}/openstack-yoga" }
    end
  end

  describe yum.repo('OSL-openstack') do
    it { should exist }
    it { should be_enabled }
    case rel
    when 10
      its('baseurl') { should include "https://ftp.osuosl.org/pub/osl/repos/yum/10/openstack-epoxy/#{arch}" }
    when 9
      its('baseurl') { should include "https://ftp.osuosl.org/pub/osl/repos/yum/9/openstack-yoga/#{arch}" }
    when 8
      its('baseurl') { should include "https://ftp.osuosl.org/pub/osl/repos/yum/8/openstack-yoga/#{arch}" }
    end
  end

  describe yum.repo('centos-nfv') do
    it { should exist }
    it { should be_enabled }
    case rel
    when 10
      its('baseurl') { should include "https://centos-stream.osuosl.org/SIGs/10-stream/nfv/#{arch}/openvswitch-2" }
    when 9
      its('baseurl') { should include "https://centos-stream.osuosl.org/SIGs/9-stream/nfv/#{arch}/openvswitch-2" }
    when 8
      its('baseurl') { should include "https://ftp.osuosl.org/pub/osl/vault/8-stream/nfv/#{arch}/openvswitch-2" }
    end
  end

  describe ini('/etc/yum.repos.d/RDO-openstack.repo') do
    its('RDO-openstack.gpgcheck') { should cmp '1' }
    its('RDO-openstack.gpgkey') { should cmp 'https://www.centos.org/keys/RPM-GPG-KEY-CentOS-SIG-Cloud' }
  end

  describe ini('/etc/yum.repos.d/OSL-openstack.repo') do
    its('OSL-openstack.gpgcheck') { should cmp '1' }
    if rel >= 9
      its('OSL-openstack.gpgkey') { should cmp 'https://ftp.osuosl.org/pub/osl/repos/yum/RPM-GPG-KEY-osuosl-2024' }
    else
      its('OSL-openstack.gpgkey') { should cmp 'https://ftp.osuosl.org/pub/osl/repos/yum/RPM-GPG-KEY-osuosl' }
    end
  end

  describe ini('/etc/yum.repos.d/centos-nfv.repo') do
    its('centos-nfv.gpgcheck') { should cmp '1' }
    its('centos-nfv.gpgkey') { should cmp 'https://centos.org/keys/RPM-GPG-KEY-CentOS-SIG-NFV' }
  end

  describe package 'python3-openstackclient' do
    it { should be_installed }
  end

  describe package 'openstack-neutron' do
    it { should be_installed }
  end
end
