control 'epel-disabled' do
  title 'Verify setting epel to false writes the repo out disabled'

  # Still managed when off, so an existing epel.repo ends up disabled
  describe yum.repo('epel') do
    it { should exist }
    it { should_not be_enabled }
  end

  describe ini('/etc/yum.repos.d/epel.repo') do
    its('epel.enabled') { should cmp '0' }
  end
end
