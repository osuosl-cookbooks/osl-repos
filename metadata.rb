name              'osl-repos'
maintainer        'Oregon State University'
maintainer_email  'chef@osuosl.org'
license           'All Rights Reserved'
description       'Installs/Configures osl-repos'
issues_url        'https://github.com/osuosl-cookbooks/osl-repos/issues'
source_url        'https://github.com/osuosl-cookbooks/osl-repos'
chef_version      '>= 16.0'
version           '5.0.1'

depends           'yum',           '~> 7.4.13'
depends           'yum-almalinux', '~> 1.1.0'
depends           'yum-epel',      '~> 5.0.0'
depends           'yum-elrepo',    '~> 2.2.0'

supports          'almalinux', '~> 8.0'
supports          'almalinux', '~> 9.0'
supports          'debian', '~> 12.0'
supports          'ubuntu', '~> 24.04'
