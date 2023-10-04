arch = File.readlines('/proc/cpuinfo').grep(/POWER9/).any? ? 'power9' : os.arch

describe ini('/etc/yum.conf') do
  its('main.distroverpkg') { should eq 'centos-release' }
  its('main.cachedir') { should eq '/var/cache/yum/$basearch/$releasever' }
  its('main.installonlypkgs') { should eq 'kernel kernel-osuosl' }
  its('main.installonly_limit') { should eq '2' }
  its('main.clean_requirements_on_remove') { should eq 'true' }
end

centos_url = arch == 'x86_64' ? 'https://centos.osuosl.org' : 'https://centos-altarch.osuosl.org'

describe yum.repo('centos-sclo') do
  it { should exist }
  it { should be_enabled }
  its('baseurl') { should eq "#{centos_url}/7/sclo/#{arch}/sclo/" }
  its('mirrors') { should eq nil }
end

describe yum.repo('centos-sclo-rh') do
  it { should exist }
  it { should be_enabled }
  its('baseurl') { should eq "#{centos_url}/7/sclo/#{arch}/rh/" }
  its('mirrors') { should eq nil }
end

describe package 'scl-utils' do
  it { should be_installed }
end
