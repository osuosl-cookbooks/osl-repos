arch = File.readlines('/proc/cpuinfo').grep(/POWER9/).any? ? 'power9' : os.arch
case os.release.to_i

when 7

  # Test the elrepo repository
  describe yum.repo('elrepo') do
    if arch == 'x86_64'
      it { should exist }
    else
      it { should_not exist }
    end
    it { should be_enabled }
    its('baseurl') { should eq 'https://ftp.osuosl.org/pub/elrepo/elrepo/el7/x86_64/' }
    its('mirrors') { should eq nil }
  end

when 8

  # Test the elrepo repository
  describe yum.repo('elrepo') do
    if arch == 'x86_64'
      it { should exist }
    else
      it { should_not exist }
    end
    it { should be_enabled }
    its('baseurl') { should eq 'https://ftp.osuosl.org/pub/elrepo/elrepo/el8/x86_64/' }
    its('mirrors') { should eq nil }
  end

end
