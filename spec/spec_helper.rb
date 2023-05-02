require 'chefspec'
require 'chefspec/berkshelf'

CENTOS_7 = {
  platform: 'centos',
  version: '7',
}.freeze

ALMA_8 = {
  platform: 'almalinux',
  version: '8',
}.freeze

ALL_PLATFORMS = [
  ALMA_8,
  CENTOS_7,
].freeze

ALL_RESOURCES = [
  :osl_repos_centos,
  :osl_repos_alma,
  :yum_alma_baseos,
  :yum_alma_appstream,
  :yum_alma_extras,
  :yum_alma_ha,
  :yum_alma_powertools,
].freeze

RSpec.configure do |config|
  config.log_level = :warn
end
