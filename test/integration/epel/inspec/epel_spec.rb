arch = File.readlines('/proc/cpuinfo').grep(/POWER9/).any? ? 'power9' : os.arch
stream = file('/etc/os-release').content.match?('Stream')

case os.release.to_i
when 7
  describe yum.repo('epel') do
    it { should exist }
    it { should be_enabled }
    its('baseurl') { should eq "https://epel.osuosl.org/7/#{arch}/" }
    its('mirrors') { should eq nil }
  end
when 8
  describe yum.repo('epel') do
    it { should exist }
    it { should be_enabled }
    its('baseurl') { should eq "https://epel.osuosl.org/8/Everything/#{arch}/" }
    its('mirrors') { should eq nil }
  end

  describe yum.repo('epel-next') do
    if stream
      it { should exist }
      it { should be_enabled }
      its('baseurl') { should eq "https://epel.osuosl.org/next/8/Everything/#{arch}/" }
      its('mirrors') { should eq nil }
    else
      it { should_not exist }
      it { should_not be_enabled }
    end
  end
end
