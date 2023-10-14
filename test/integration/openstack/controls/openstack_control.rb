control 'openstack' do
  title 'Verify elevate yum repo is configured'

  rel = os[:release].to_i
  arch = os[:arch]

  describe yum.repo('RDO-openstack') do
    it { should exist }
    it { should be_enabled }
    case rel
    when 9
      its('baseurl') { should include "https://centos-stream.osuosl.org/SIGs/9-stream/cloud/#{arch}/openstack-yoga" }
    when 8
      its('baseurl') { should include "https://ftp.osuosl.org/pub/osl/rdo/8/#{arch}/openstack-train" }
    when 7
      its('baseurl') { should include "https://centos.osuosl.org/7/cloud/#{arch}/openstack-stein" }
    end
  end

  describe ini('/etc/yum.repos.d/RDO-openstack.repo') do
    its('RDO-openstack.gpgcheck') { should cmp '1' }
    its('RDO-openstack.gpgkey') { should cmp 'https://www.centos.org/keys/RPM-GPG-KEY-CentOS-SIG-Cloud' }
  end

  osc_pkg = rel == 7 ? 'python2-openstackclient' : 'python3-openstackclient'

  describe package osc_pkg do
    it { should be_installed }
  end
end
