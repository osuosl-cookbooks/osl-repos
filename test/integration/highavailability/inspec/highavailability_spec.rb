# Test for the main configuration file ('/etc/yum.conf'cookstyle)
describe ini('/etc/yum.conf') do
  its('main.installonlypkgs') { should eq 'kernel kernel-osuosl' }
  its('main.installonly_limit') { should eq '2' }
end

arch = File.readlines('/proc/cpuinfo').grep(/POWER9/).any? ? 'power9' : os.arch
rel = os.release.to_i

case os.release.to_i
when 8
  url = 'almalinux.osuosl.org'

  describe yum.repo('appstream') do
    it { should exist }
    it { should be_enabled }
    its('baseurl') { should eq "https://#{url}/#{rel}/AppStream/#{arch}/os/" }
    its('mirrors') { should eq nil }
  end

  describe yum.repo('baseos') do
    it { should exist }
    it { should be_enabled }
    its('baseurl') { should eq "https://#{url}/#{rel}/BaseOS/#{arch}/os/" }
    its('mirrors') { should eq nil }
  end

  describe yum.repo('extras') do
    it { should exist }
    it { should be_enabled }
    its('baseurl') { should eq "https://#{url}/#{rel}/extras/#{arch}/os/" }
    its('mirrors') { should eq nil }
  end

  describe yum.repo('highavailability') do
    it { should exist }
    it { should be_enabled }
    its('baseurl') { should eq "https://#{url}/#{rel}/HighAvailability/#{arch}/os/" }
    its('mirrors') { should eq nil }
  end

  describe yum.repo('powertools') do
    it { should exist }
    it { should be_enabled }
    its('baseurl') { should eq "https://#{url}/#{rel}/PowerTools/#{arch}/os/" }
    its('mirrors') { should eq nil }
  end
end
