control 'centos-kmods' do
  title 'Verify centos-kmods yum repos are configured'

  rel = os[:release].to_i
  arch = os[:arch]
  kernel = rel < 9 ? '6.6' : '6.18'
  gpgkey = 'https://www.centos.org/keys/RPM-GPG-KEY-CentOS-SIG-Kmods'

  {
    'centos-kmods' => 'packages-main',
    'centos-kmods-rebuild' => 'packages-rebuild',
    'centos-kmods-userspace' => 'packages-userspace',
    "centos-kmods-kernel-#{kernel}" => "kernel-#{kernel}",
  }.each do |repo, path|
    describe yum.repo(repo) do
      it { should exist }
      it { should be_enabled }
      its('baseurl') { should include "https://centos-stream.osuosl.org/SIGs/#{rel}/kmods/#{arch}/#{path}/" }
    end

    describe ini("/etc/yum.repos.d/#{repo}.repo") do
      its([repo, 'gpgcheck']) { should cmp '1' }
      its([repo, 'gpgkey']) { should cmp gpgkey }
    end
  end

  describe ini("/etc/yum.repos.d/centos-kmods-kernel-#{kernel}.repo") do
    its(["centos-kmods-kernel-#{kernel}", 'exclude']) { should cmp 'kernel-headers kernel-cross-headers' }
  end

  (%w(6.1 6.6 6.12 6.18 latest) - [kernel]).each do |other|
    describe yum.repo("centos-kmods-kernel-#{other}") do
      it { should_not exist }
    end
  end
end
