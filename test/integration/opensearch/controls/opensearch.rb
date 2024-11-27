control 'opensearch' do
  title 'Verify opensearch repo is configured'

  family = os.family

  describe yum.repo('opensearch') do
    it { should exist }
    it { should be_enabled }
    its('baseurl') { should include 'https://artifacts.opensearch.org/releases/bundle/opensearch/2.x/yum' }
  end if family == 'redhat'

  describe yum.repo('opensearch-dashboards') do
    it { should exist }
    it { should be_enabled }
    its('baseurl') { should include 'https://artifacts.opensearch.org/releases/bundle/opensearch-dashboards/2.x/yum' }
  end if family == 'redhat'

  describe ini('/etc/yum.repos.d/opensearch-dashboards.repo') do
    its('opensearch-dashboards.gpgcheck') { should cmp '1' }
    its('opensearch-dashboards.gpgkey') { should cmp 'https://artifacts.opensearch.org/publickeys/opensearch.pgp' }
  end if family == 'redhat'

  describe package 'opensearch' do
    it { should be_installed }
  end

  describe package 'opensearch-dashboards' do
    it { should be_installed }
  end
end
