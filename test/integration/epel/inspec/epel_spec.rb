# There will be different cases for the Centos 7 and Centos 8 repositories
case os.release.to_i

####### Begin Centos 7 Case #######
when 7

  # Test the epel repository
  describe yum.repo('epel') do
    it { should exist }
    it { should be_enabled }
    its('baseurl') { should eq 'https://epel.osuosl.org/7/x86_64/' }
    its('mirrors') { should eq nil }
  end

####### Begin Centos 8 Case #######
when 8

  # Test the epel repository
  describe yum.repo('epel') do
    it { should exist }
    it { should be_enabled }
    its('baseurl') { should eq 'https://epel.osuosl.org/8/Everything/x86_64/' }
    its('mirrors') { should eq nil }
  end

end
