control 'hashicorp' do
  title 'Verify hashicorp repo is configured'

  family = os.family
  rel = os.release.to_i
  arch = os.arch

  repo_rel = rel >= 10 ? 9 : rel
  yum_repo_baseurl = "https://rpm.releases.hashicorp.com/RHEL/#{repo_rel}/#{arch}/stable"

  describe yum.repo('hashicorp') do
    it { should exist }
    it { should be_enabled }
    its('baseurl') { should include yum_repo_baseurl }
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
