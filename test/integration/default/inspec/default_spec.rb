# Test for the main configuration file ('/etc/yum.conf'cookstyle)
describe file('/etc/yum.conf') do
  its('content') { should match /^installonlypkgs=kernel kernel-osuosl/ }
  its('content') { should match /^installonly_limit=2/ }
end

# There will be different cases for the Centos 7 and Centos 8 repositories
case os.release.to_i

####### Begin Centos 7 Case #######
when 7

  # Test the base repository
  describe yum.repo('base') do
    it { should exist }
    it { should be_enabled }
    its('baseurl') { should eq 'http://centos.osuosl.org/7/os/x86_64/' }
    its('mirrors') { should eq nil }
  end

  # Test the epel repository
  describe yum.repo('epel') do
    it { should exist }
    it { should be_enabled }
    its('baseurl') { should eq 'http://epel.osuosl.org/7/x86_64/' }
    its('mirrors') { should eq nil }
  end

  # Test the extras repository
  describe yum.repo('extras') do
    it { should exist }
    it { should be_enabled }
    its('baseurl') { should eq 'http://centos.osuosl.org/7/extras/x86_64/' }
    its('mirrors') { should eq nil }
  end

  # Test the updates repository
  describe yum.repo('updates') do
    it { should exist }
    it { should be_enabled }
    its('baseurl') { should eq 'http://centos.osuosl.org/7/updates/x86_64/' }
    its('mirrors') { should eq nil }
  end

####### Begin Centos 8 Case #######
when 8

  # Test the appstream repository
  describe yum.repo('appstream') do
    it { should exist }
    it { should be_enabled }
    its('baseurl') { should eq 'http://centos.osuosl.org/8/AppStream/x86_64/os' }
    its('mirrors') { should eq nil }
  end

  # Test the base repository
  describe yum.repo('base') do
    it { should exist }
    it { should be_enabled }
    its('baseurl') { should eq 'http://centos.osuosl.org/8/BaseOS/x86_64/os' }
    its('mirrors') { should eq nil }
  end

  # Test the elrepo repository
  describe yum.repo('elrepo') do
    it { should exist }
    it { should be_enabled }
    its('baseurl') { should eq 'http://ftp.osuosl.org/pub/elrepo/elrepo/el8/x86_64/' }
    its('mirrors') { should eq nil }
  end

  # Test the epel repository
  describe yum.repo('epel') do
    it { should exist }
    it { should be_enabled }
    its('baseurl') { should eq 'http://epel.osuosl.org/8/Everything/x86_64/' }
    its('mirrors') { should eq nil }
  end

  # Test the extras repository
  describe yum.repo('extras') do
    it { should exist }
    it { should be_enabled }
    its('baseurl') { should eq 'http://centos.osuosl.org/8/extras/x86_64/os' }
    its('mirrors') { should eq nil }
  end

  # Test the powertools repository
  describe yum.repo('powertools') do
    it { should exist }
    it { should be_enabled }
    its('baseurl') { should eq 'http://centos.osuosl.org/8/PowerTools/x86_64/os' }
    its('mirrors') { should eq nil }
  end
end
