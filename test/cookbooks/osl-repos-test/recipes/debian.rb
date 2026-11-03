# Seed the pin 5.1.0 to 5.11.0 wrote on trixie, so the suite proves osl-repos::debian deletes it
execute 'seed stale 99osuosl pin' do
  command "printf 'APT::Default-Release \"trixie\";\\n' > /etc/apt/apt.conf.d/99osuosl && touch /var/tmp/osl-repos-99osuosl-seeded"
  creates '/var/tmp/osl-repos-99osuosl-seeded'
end if node['platform_version'].to_i == 13

include_recipe 'osl-repos::debian'
