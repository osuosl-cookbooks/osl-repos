arch = os.arch
rel = os.release.to_i

describe yum.repo('epel') do
  it { should exist }
  it { should be_enabled }
  its('baseurl') { should eq "https://epel.osuosl.org/#{rel}/Everything/#{arch}/" }
  its('mirrors') { should eq nil }
end

describe yum.repo('epel-next') do
  it { should_not exist }
  it { should_not be_enabled }
end
