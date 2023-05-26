describe ini('/etc/yum.conf') do
  its('main.distroverpkg') { should eq nil }
  its('main.cachedir') { should eq '/var/cache/dnf' }
  its('main.installonlypkgs') { should eq 'kernel kernel-osuosl' }
  its('main.installonly_limit') { should eq '2' }
  its('main.clean_requirements_on_remove') { should eq 'true' }
end

rel = os.release.to_i

describe yum.repo('appstream') do
  it { should exist }
  it { should be_enabled }
  its('baseurl') { should eq "https://almalinux.osuosl.org/#{rel}/AppStream/x86_64/os/" }
  its('mirrors') { should eq nil }
end

describe yum.repo('baseos') do
  it { should exist }
  it { should be_enabled }
  its('baseurl') { should eq "https://almalinux.osuosl.org/#{rel}/BaseOS/x86_64/os/" }
  its('mirrors') { should eq nil }
end

describe yum.repo('extras') do
  it { should exist }
  it { should be_enabled }
  its('baseurl') { should eq "https://almalinux.osuosl.org/#{rel}/extras/x86_64/os/" }
  its('mirrors') { should eq nil }
end

describe yum.repo('highavailability') do
  it { should exist }
  it { should_not be_enabled }
  its('baseurl') { should eq "https://almalinux.osuosl.org/#{rel}/HighAvailability/x86_64/os/" }
  its('mirrors') { should eq nil }
end

describe yum.repo('powertools') do
  it { should exist }
  it { should be_enabled }
  its('baseurl') { should eq "https://almalinux.osuosl.org/#{rel}/PowerTools/x86_64/os/" }
  its('mirrors') { should eq nil }
end if rel == 8

describe yum.repo('crb') do
  it { should exist }
  it { should be_enabled }
  its('baseurl') { should eq "https://almalinux.osuosl.org/#{rel}/CRB/x86_64/os/" }
  its('mirrors') { should eq nil }
end if rel >= 9
