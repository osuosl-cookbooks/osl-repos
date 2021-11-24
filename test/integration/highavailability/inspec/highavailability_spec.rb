# Test for the main configuration file ('/etc/yum.conf'cookstyle)
describe ini('/etc/yum.conf') do
  its('main.installonlypkgs') { should eq 'kernel kernel-osuosl' }
  its('main.installonly_limit') { should eq '2' }
end

arch = File.readlines('/proc/cpuinfo').grep(/POWER9/).any? ? 'power9' : os.arch
stream = file('/etc/os-release').content.match?('Stream')
rel = stream ? "#{os.release.to_i}-stream" : os.release.to_i

case os.release.to_i
when 7
  centos_url = arch == 'x86_64' ? 'https://centos.osuosl.org' : 'https://centos-altarch.osuosl.org'

  describe yum.repo('base') do
    it { should exist }
    it { should be_enabled }
    its('baseurl') { should eq "#{centos_url}/7/os/#{arch}/" }
    its('mirrors') { should eq nil }
  end

  describe yum.repo('extras') do
    it { should exist }
    it { should be_enabled }
    its('baseurl') { should eq "#{centos_url}/7/extras/#{arch}/" }
    its('mirrors') { should eq nil }
  end

  describe yum.repo('updates') do
    it { should exist }
    it { should be_enabled }
    its('baseurl') { should eq "#{centos_url}/7/updates/#{arch}/" }
    its('mirrors') { should eq nil }
  end
when 8
  describe yum.repo('appstream') do
    it { should exist }
    it { should be_enabled }
    its('baseurl') { should eq "https://centos.osuosl.org/#{rel}/AppStream/#{arch}/os/" }
    its('mirrors') { should eq nil }
  end

  describe yum.repo('base') do
    it { should exist }
    it { should be_enabled }
    its('baseurl') { should eq "https://centos.osuosl.org/#{rel}/BaseOS/#{arch}/os/" }
    its('mirrors') { should eq nil }
  end

  describe yum.repo('extras') do
    it { should exist }
    it { should be_enabled }
    its('baseurl') { should eq "https://centos.osuosl.org/#{rel}/extras/#{arch}/os/" }
    its('mirrors') { should eq nil }
  end

  describe yum.repo('highavailability') do
    it { should exist }
    it { should be_enabled }
    its('baseurl') { should eq "https://centos.osuosl.org/#{rel}/HighAvailability/#{arch}/os/" }
    its('mirrors') { should eq nil }
  end

  describe yum.repo('powertools') do
    it { should exist }
    it { should be_enabled }
    its('baseurl') { should eq "https://centos.osuosl.org/#{rel}/PowerTools/#{arch}/os/" }
    its('mirrors') { should eq nil }
  end
end
