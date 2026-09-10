control 'elrepo-merged' do
  title 'Verify separate osl_repos_elrepo declarations merge into a single repo'

  rel = os.release.to_i

  describe yum.repo('elrepo') do
    it { should exist }
    it { should be_enabled }
    its('baseurl') { should eq "https://ftp.osuosl.org/pub/elrepo/elrepo/el#{rel}/x86_64/" }
    its('mirrors') { should eq nil }
  end

  # Each declaration contributes one exclude, the repo carries the union
  describe ini('/etc/yum.repos.d/elrepo.repo') do
    its('elrepo.exclude') { should cmp 'kmod-foo kmod-bar' }
    its('elrepo.name') { should cmp "ELRepo.org Community Enterprise Linux Repository - el#{rel}" }
  end
end
