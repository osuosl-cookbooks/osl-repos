name              'osl-repos'
maintainer        'Oregon State University'
maintainer_email  'chef@osuosl.org'
license           'All Rights Reserved'
description       'Installs/Configures osl-repos'
issues_url        'https://github.com/osuosl-cookbooks/osl-repos/issues'
source_url        'https://github.com/osuosl-cookbooks/osl-repos'
chef_version      '>= 15.0'
version           '0.1.0'

depends           'yum', '~> 5.1.0'
depends           'yum-centos', '~> 4.0'
depends           'yum-epel', '~> 3.3.0'
depends           'yum-elrepo'

supports          'centos', '~> 7.0'
supports          'centos', '~> 8.0'
