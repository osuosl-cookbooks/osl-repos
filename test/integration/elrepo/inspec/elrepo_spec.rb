arch = File.readlines('/proc/cpuinfo').grep(/POWER9/).any? ? 'power9' : os.arch
# Test the elrepo repository
describe yum.repo('elrepo') do
  if arch == 'x86_64'
    it { should exist }
  else
    it { should_not exist }
  end
  it { should be_enabled }
  its('baseurl') { should eq "https://ftp.osuosl.org/pub/elrepo/elrepo/el#{os.release.to_i}/x86_64/" }
  its('mirrors') { should eq nil }
end
