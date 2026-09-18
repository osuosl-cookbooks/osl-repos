control 'elevate' do
  title 'Verify centos-kmods yum repos are configured'

  rel = os[:release].to_i
  arch = os[:arch]

  describe yum.repo('centos-kmods') do
    it { should exist }
    it { should be_enabled }
    its('baseurl') { should include "https://centos-stream.osuosl.org/SIGs/#{rel}/kmods/#{arch}/packages-main/" }
  end

  describe yum.repo('centos-kmods-rebuild') do
    it { should exist }
    it { should be_enabled }
    its('baseurl') { should include "https://centos-stream.osuosl.org/SIGs/#{rel}/kmods/#{arch}/packages-rebuild/" }
  end

  describe yum.repo('centos-kmods-userspace') do
    it { should exist }
    it { should be_enabled }
    its('baseurl') { should include "https://centos-stream.osuosl.org/SIGs/#{rel}/kmods/#{arch}/packages-userspace/" }
  end

  describe yum.repo('centos-kmods-kernel-6.1') do
    if rel < 10
      it { should exist }
      it { should be_enabled }
      its('baseurl') { should include "https://centos-stream.osuosl.org/SIGs/#{rel}/kmods/#{arch}/kernel-6.1/" }
    else
      it { should_not exist }
      it { should_not be_enabled }
    end
  end

  describe yum.repo('centos-kmods-kernel-6.6') do
    if rel < 10
      it { should exist }
      it { should be_enabled }
      its('baseurl') { should include "https://centos-stream.osuosl.org/SIGs/#{rel}/kmods/#{arch}/kernel-6.6/" }
    else
      it { should_not exist }
      it { should_not be_enabled }
    end
  end

  %w(
    centos-kmods
    centos-kmods-rebuild
    centos-kmods-userspace
  ).each do |r|
    describe ini("/etc/yum.repos.d/#{r}.repo") do
      its("#{r}.gpgcheck") { should cmp '1' }
      its("#{r}.gpgkey") { should cmp 'https://www.centos.org/keys/RPM-GPG-KEY-CentOS-SIG-Kmods' }
    end
  end

  describe ini('/etc/yum.repos.d/centos-kmods-kernel-6.1.repo') do
    its(['centos-kmods-kernel-6.1', 'gpgcheck']) { should cmp '1' }
    its(['centos-kmods-kernel-6.1', 'gpgkey']) { should cmp 'https://www.centos.org/keys/RPM-GPG-KEY-CentOS-SIG-Kmods' }
  end if rel < 10

  describe ini('/etc/yum.repos.d/centos-kmods-kernel-6.6.repo') do
    its(['centos-kmods-kernel-6.6', 'gpgcheck']) { should cmp '1' }
    its(['centos-kmods-kernel-6.6', 'gpgkey']) { should cmp 'https://www.centos.org/keys/RPM-GPG-KEY-CentOS-SIG-Kmods' }
  end if rel < 10

  if rel >= 9
    describe ini('/etc/yum.repos.d/centos-kmods-kernel-latest.repo') do
      its('centos-kmods-kernel-latest.gpgcheck') { should cmp '1' }
      its('centos-kmods-kernel-latest.gpgkey') { should cmp 'https://www.centos.org/keys/RPM-GPG-KEY-CentOS-SIG-Kmods' }
    end

    describe yum.repo('centos-kmods-kernel-latest') do
      it { should exist }
      it { should be_enabled }
      its('baseurl') { should include "https://centos-stream.osuosl.org/SIGs/#{rel}/kmods/#{arch}/kernel-latest/" }
    end
  else
    describe yum.repo('centos-kmods-kernel-latest') do
      it { should_not exist }
      it { should_not be_enabled }
    end
  end
end
