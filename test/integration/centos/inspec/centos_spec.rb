arch = File.readlines('/proc/cpuinfo').grep(/POWER9/).any? ? 'power9' : os.arch
case os.release.to_i

when 7
  describe ini('/etc/yum.conf') do
    its('main.distroverpkg') { should eq 'centos-release' }
    its('main.cachedir') { should eq '/var/cache/yum/$basearch/$releasever' }
    its('main.installonlypkgs') { should eq 'kernel kernel-osuosl' }
    its('main.installonly_limit') { should eq '2' }
    its('main.clean_requirements_on_remove') { should eq 'true' }
  end

  centos_url = arch == 'x86_64' ? 'https://centos.osuosl.org' : 'https://centos-altarch.osuosl.org'

  # Test the base repository
  describe yum.repo('base') do
    it { should exist }
    it { should be_enabled }
    its('baseurl') { should eq "#{centos_url}/7/os/#{arch}/" }
    its('mirrors') { should eq nil }
  end

  # Test the extras repository
  describe yum.repo('extras') do
    it { should exist }
    it { should be_enabled }
    its('baseurl') { should eq "#{centos_url}/7/extras/#{arch}/" }
    its('mirrors') { should eq nil }
  end

  # Test the updates repository
  describe yum.repo('updates') do
    it { should exist }
    it { should be_enabled }
    its('baseurl') { should eq "#{centos_url}/7/updates/#{arch}/" }
    its('mirrors') { should eq nil }
  end

when 8
  describe ini('/etc/yum.conf') do
    its('main.distroverpkg') { should eq nil }
    its('main.cachedir') { should eq '/var/cache/dnf' }
    its('main.installonlypkgs') { should eq 'kernel kernel-osuosl' }
    its('main.installonly_limit') { should eq '2' }
    its('main.clean_requirements_on_remove') { should eq 'true' }
  end

  # Test the appstream repository
  describe yum.repo('appstream') do
    it { should exist }
    it { should be_enabled }
    its('baseurl') { should eq "https://centos.osuosl.org/8/AppStream/#{arch}/os/" }
    its('mirrors') { should eq nil }
  end

  # Test the base repository
  describe yum.repo('base') do
    it { should exist }
    it { should be_enabled }
    its('baseurl') { should eq "https://centos.osuosl.org/8/BaseOS/#{arch}/os/" }
    its('mirrors') { should eq nil }
  end

  # Test the extras repository
  describe yum.repo('extras') do
    it { should exist }
    it { should be_enabled }
    its('baseurl') { should eq "https://centos.osuosl.org/8/extras/#{arch}/os/" }
    its('mirrors') { should eq nil }
  end

  # Test the extras repository
  describe yum.repo('highavailability') do
    it { should exist }
    it { should_not be_enabled }
    its('baseurl') { should eq "https://centos.osuosl.org/8/HighAvailability/#{arch}/os/" }
    its('mirrors') { should eq nil }
  end

  # Test the powertools repository
  describe yum.repo('powertools') do
    it { should exist }
    it { should be_enabled }
    its('baseurl') { should eq "https://centos.osuosl.org/8/PowerTools/#{arch}/os/" }
    its('mirrors') { should eq nil }
  end
end
