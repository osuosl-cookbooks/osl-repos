control 'hashicorp' do
  title 'Verify hashicorp repo is configured'

  family = os.family
  rel = os.release.to_i
  arch = os.arch

  describe yum.repo('hashicorp') do
    it { should exist }
    it { should be_enabled }
    its('baseurl') { should include "https://rpm.releases.hashicorp.com/RHEL/#{rel}/#{arch}/stable" }
  end if family == 'redhat'

  describe ini('/etc/yum.repos.d/hashicorp.repo') do
    its('hashicorp.gpgcheck') { should cmp '1' }
    its('hashicorp.gpgkey') { should cmp 'https://rpm.releases.hashicorp.com/gpg' }
  end if family == 'redhat'

  describe apt 'https://apt.releases.hashicorp.com/' do
    it { should exist }
    it { should be_enabled }
  end if family == 'debian'

  %w(
    packer
    terraform
    vagrant
  ).each do |p|
    describe package p do
      it { should be_installed }
    end
  end
end
