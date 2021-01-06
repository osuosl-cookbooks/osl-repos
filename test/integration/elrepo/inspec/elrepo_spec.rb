# There will be different cases for the Centos 7 and Centos 8 repositories
case os.release.to_i

# Begin Centos 7 Case
when 7

  # Test the elrepo repository
  describe yum.repo('elrepo') do
    it { should exist }
    it { should be_enabled }
    its('baseurl') { should eq 'https://ftp.osuosl.org/pub/elrepo/elrepo/el7/x86_64/' }
    its('mirrors') { should eq nil }
  end

# Begin Centos 8 Case
when 8

  # Test the elrepo repository
  describe yum.repo('elrepo') do
    it { should exist }
    it { should be_enabled }
    its('baseurl') { should eq 'https://ftp.osuosl.org/pub/elrepo/elrepo/el8/x86_64/' }
    its('mirrors') { should eq nil }
  end

end
