control 'elasticsearch' do
  title 'Verify elasticsearch repo is configured'

  family = os.family

  describe yum.repo('elasticsearch') do
    it { should exist }
    it { should be_enabled }
    its('baseurl') { should include 'https://artifacts.elastic.co/packages/8.x/yum' }
  end if family == 'redhat'

  describe ini('/etc/yum.repos.d/elasticsearch.repo') do
    its('elasticsearch.gpgcheck') { should cmp '1' }
    its('elasticsearch.gpgkey') { should cmp 'https://artifacts.elastic.co/GPG-KEY-elasticsearch' }
  end if family == 'redhat'

  describe package 'logstash' do
    it { should be_installed }
  end
end
