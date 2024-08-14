require_relative '../../spec_helper'

describe 'osl-repos::debian' do
  [DEBIAN_12].each do |p|
    context "#{p[:platform]} #{p[:version]}" do
      cached(:chef_run) do
        ChefSpec::SoloRunner.new(p).converge(described_recipe)
      end

      it 'converges successfully' do
        expect { chef_run }.to_not raise_error
      end

      it { is_expected.to nothing_apt_update 'update' }
      it { is_expected.to create_template('/etc/apt/sources.list').with(source: 'debian.sources.list.erb') }
      it do
        is_expected.to render_file('/etc/apt/sources.list').with_content(
            <<~EOF
              # sources.list file written by Chef
              deb https://debian.osuosl.org/debian bookworm main non-free non-free-firmware contrib
              deb https://debian.osuosl.org/debian bookworm-updates main non-free non-free-firmware contrib
              deb https://debian.osuosl.org/debian bookworm-backports main non-free non-free-firmware contrib
              deb https://deb.debian.org/debian-security bookworm-security main non-free non-free-firmware contrib
            EOF
          )
      end
      it { expect(chef_run.template('/etc/apt/sources.list')).to notify('apt_update[update]').to(:update).immediately }
      it { is_expected.to_not create_file('/etc/apt/apt.conf.d/99osuosl') }
      it { is_expected.to install_package(%w(unattended-upgrades apt-listchanges)) }
      it do
        is_expected.to create_cookbook_file('/etc/apt/apt.conf.d/50unattended-upgrades').with(
          source: 'debian-50unattended-upgrades'
        )
      end
      it do
        expect(chef_run.cookbook_file('/etc/apt/apt.conf.d/50unattended-upgrades')).to \
          notify('service[unattended-upgrades.service]').to(:restart)
      end

      it { is_expected.to enable_service 'unattended-upgrades.service' }
      it { is_expected.to start_service 'unattended-upgrades.service' }
      it { is_expected.to enable_service 'apt-daily-upgrade.timer' }
      it { is_expected.to start_service 'apt-daily-upgrade.timer' }

      context 'trixie' do
        cached(:chef_run) do
          ChefSpec::SoloRunner.new(p) do |node|
            node.automatic['lsb']['codename'] = 'trixie'
          end.converge(described_recipe)
        end
        it do
          is_expected.to render_file('/etc/apt/sources.list').with_content(
              <<~EOF
                # sources.list file written by Chef
                deb https://debian.osuosl.org/debian trixie main non-free non-free-firmware contrib
                deb https://debian.osuosl.org/debian trixie-updates main non-free non-free-firmware contrib
                deb https://debian.osuosl.org/debian trixie-backports main non-free non-free-firmware contrib
              EOF
            )
        end
        it do
          is_expected.to create_file('/etc/apt/apt.conf.d/99osuosl').with(content: 'APT::Default-Release "trixie";')
        end
      end
    end
  end
end
