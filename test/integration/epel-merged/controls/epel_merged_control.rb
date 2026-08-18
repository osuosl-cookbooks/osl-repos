control 'epel-merged' do
  title 'Verify separate osl_repos_epel declarations merge into a single repo'

  arch = os.arch
  rel = os.release.to_i

  describe yum.repo('epel') do
    it { should exist }
    it { should be_enabled }
    if rel >= 10
      its('baseurl') { should eq "https://epel.osuosl.org/10z/Everything/#{arch}/" }
    else
      its('baseurl') { should eq "https://epel.osuosl.org/#{rel}/Everything/#{arch}/" }
    end
    its('mirrors') { should eq nil }
  end

  # Each declaration contributes one exclude, the repo carries the union
  describe ini('/etc/yum.repos.d/epel.repo') do
    its('epel.exclude') { should cmp 'foo bar' }
    its('epel.enabled') { should cmp '1' }
  end
end
