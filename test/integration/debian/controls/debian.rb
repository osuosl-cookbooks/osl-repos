control 'debian' do
  release_name =
  case os.release.to_i
  when 12
    'bookworm'
  when 13
    'trixie'
  end

  expected_sources = [
        '# sources.list file written by Chef',
        "deb https://debian.osuosl.org/debian #{release_name} main non-free non-free-firmware contrib",
        "deb https://debian.osuosl.org/debian #{release_name}-updates main non-free non-free-firmware contrib",
        "deb https://debian.osuosl.org/debian #{release_name}-backports main non-free non-free-firmware contrib",
  ]

  if os.release.to_i == 12
    expected_sources << "deb https://deb.debian.org/debian-security #{release_name}-security main non-free non-free-firmware contrib"
  end

  describe file '/etc/apt/sources.list' do
    its('content') { should cmp expected_sources.join("\n") + "\n" }
  end

  if os.release.to_i == 12
    describe file '/etc/apt/apt.conf.d/99osuosl' do
      it { should_not exist }
    end
  end

  %w(
    unattended-upgrades
    apt-listchanges
  ).each do |p|
    describe package p do
      it { should be_installed }
    end
  end

  describe file '/etc/apt/apt.conf.d/50unattended-upgrades' do
    its('content') { should match /file written by Chef/ }
  end

  %w(
    unattended-upgrades.service
    apt-daily-upgrade.timer
  ).each do |s|
    describe service s do
      it { should be_enabled }
      it { should be_running }
    end
  end
end
