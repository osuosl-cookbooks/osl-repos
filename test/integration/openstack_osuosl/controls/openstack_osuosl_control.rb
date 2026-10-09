control 'openstack_osuosl' do
  title 'Verify the OSL-built (osuosl) OpenStack yum repo is configured'

  rel = os[:release].to_i
  arch = os[:arch]

  release =
    case rel
    when 10
      'epoxy'
    else
      'yoga'
    end

  describe yum.repo('OSL-openstack') do
    it { should exist }
    it { should be_enabled }
    its('baseurl') { should include "https://ftp.osuosl.org/pub/osl/repos/yum/#{rel}/openstack/#{release}/#{arch}" }
  end

  describe ini('/etc/yum.repos.d/OSL-openstack.repo') do
    its('OSL-openstack.gpgcheck') { should cmp '1' }
    its('OSL-openstack.gpgkey') { should cmp 'https://ftp.osuosl.org/pub/osl/repos/yum/RPM-GPG-KEY-osuosl-2024' }
    its('OSL-openstack.metadata_expire') { should cmp '15m' }
  end

  # The staged next release is written disabled
  describe yum.repo('OSL-openstack-zed') do
    it { should exist }
    it { should_not be_enabled }
    its('baseurl') { should include "https://ftp.osuosl.org/pub/osl/repos/yum/#{rel}/openstack/zed/#{arch}" }
  end

  # The :osuosl source must NOT pull in any of the RDO-era repos.
  describe yum.repo('RDO-openstack') do
    it { should_not exist }
  end

  describe yum.repo('centos-nfv') do
    it { should_not exist }
  end

  describe yum.repo('OSL-openstack-power10') do
    it { should_not exist }
  end

  # Smoke-test: install must succeed where the recipe attempts it.
  if rel == 9 && arch == 'x86_64'
    describe package 'osuosl-openstack-keystone' do
      it { should be_installed }
    end
  end
end
