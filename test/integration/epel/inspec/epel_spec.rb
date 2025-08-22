arch = os.arch
rel = os.release.to_i
full_rel = os.release

describe yum.repo('epel') do
  it { should exist }
  it { should be_enabled }
  if rel >= 10
    its('baseurl') { should eq "https://epel.osuosl.org/#{full_rel}/Everything/#{arch}/" }
  else
    its('baseurl') { should eq "https://epel.osuosl.org/#{rel}/Everything/#{arch}/" }
  end
  its('mirrors') { should eq nil }
end

describe yum.repo('epel-next') do
  it { should_not exist }
  it { should_not be_enabled }
end
