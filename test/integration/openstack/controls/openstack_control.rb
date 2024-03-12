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
    end
  end

  describe ini('/etc/yum.repos.d/RDO-openstack.repo') do
    its('RDO-openstack.gpgcheck') { should cmp '1' }
    its('RDO-openstack.gpgkey') { should cmp 'https://www.centos.org/keys/RPM-GPG-KEY-CentOS-SIG-Cloud' }
  end

  describe package 'python3-openstackclient' do
    it { should be_installed }
  end
end
