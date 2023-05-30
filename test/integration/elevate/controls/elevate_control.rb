control 'elevate' do
  title 'Verify elevate yum repo is configured'

  rel = os[:release].to_i
  arch = os[:arch]

  describe yum.repo('elevate') do
    it { should exist }
    it { should be_enabled }
    its('baseurl') { should include "https://repo.almalinux.org/elevate/el#{rel}/#{arch}/" }
  end

  describe ini('/etc/yum.repos.d/elevate.repo') do
    its('elevate.gpgcheck') { should cmp '1' }
    its('elevate.gpgkey') { should cmp 'https://repo.almalinux.org/elevate/RPM-GPG-KEY-ELevate' }
  end

  describe package "leapp-upgrade-el#{rel}toel#{rel + 1}" do
    it { should be_installed }
  end
  describe package 'leapp-data-almalinux' do
    it { should be_installed }
  end
end
