control 'oslrepo' do
  title 'Verify osl yum repo is configured'

  rel = os[:release].to_i
  arch = os[:arch]

  describe yum.repo('osl') do
    it { should exist }
    it { should be_enabled }
    its('baseurl') { should include "http://packages.osuosl.org/repositories/centos-#{rel}/osl/#{arch}" }
  end

  describe file('/etc/yum.repos.d/osl.repo') do
    its('content') { should match /gpgcheck=0/ }
  end

  describe ini('/etc/yum.repos.d/osl.repo') do
    its('osl.baseurl') { should cmp 'http://packages.osuosl.org/repositories/centos-$releasever/osl/$basearch' }
    its('osl.gpgcheck') { should cmp '0' }
  end
end