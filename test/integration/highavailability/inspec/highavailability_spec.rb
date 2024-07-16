# Test for the main configuration file ('/etc/yum.conf'cookstyle)
describe ini('/etc/yum.conf') do
  its('main.installonlypkgs') { should eq 'kernel kernel-osuosl' }
  its('main.installonly_limit') { should eq '2' }
end

arch = os.arch
rel = os.release.to_i
power_tools = os.release.to_i >= 9 ? 'CRB' : 'PowerTools'
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

describe yum.repo(power_tools.downcase) do
  it { should exist }
  it { should be_enabled }
  its('baseurl') { should eq "https://#{url}/#{rel}/#{power_tools}/#{arch}/os/" }
  its('mirrors') { should eq nil }
end
