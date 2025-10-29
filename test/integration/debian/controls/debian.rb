control 'debian' do
  if os.release.to_i == 12
    describe file '/etc/apt/sources.list' do
      its('content') do
        should cmp <<~EOF
          # sources.list file written by Chef
          deb https://debian.osuosl.org/debian bookworm main non-free non-free-firmware contrib
          deb https://debian.osuosl.org/debian bookworm-updates main non-free non-free-firmware contrib
          deb https://debian.osuosl.org/debian bookworm-backports main non-free non-free-firmware contrib
          deb https://deb.debian.org/debian-security bookworm-security main non-free non-free-firmware contrib
        EOF
      end
    end
  end
  if os.release.to_i == 13
    describe file '/etc/apt/sources.list' do
      its('content') do
        should cmp <<~EOF
          # sources.list file written by Chef
          deb https://debian.osuosl.org/debian trixie main non-free non-free-firmware contrib
          deb https://debian.osuosl.org/debian trixie-updates main non-free non-free-firmware contrib
          deb https://debian.osuosl.org/debian trixie-backports main non-free non-free-firmware contrib
        EOF
      end
    end
  end

  if os.release.to_i == 12
    describe file '/etc/apt/apt.conf.d/99osuosl' do
      it { should_not exist }
    end
  end
  if os.release.to_i == 13
    describe file '/etc/apt/apt.conf.d/99osuosl' do
      it { should exist }
      its('content') { should match('APT::Default-Release "trixie";') }
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
    its('content') { should match(/file written by Chef/) }
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
