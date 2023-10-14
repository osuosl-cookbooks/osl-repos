require 'chefspec'
require 'chefspec/berkshelf'

ALMA_8 = {
  platform: 'almalinux',
  version: '8',
}.freeze

ALMA_9 = {
  platform: 'almalinux',
  version: '9',
}.freeze

CENTOS_7 = {
  platform: 'centos',
  version: '7',
}.freeze

DEBIAN_11 = {
  platform: 'debian',
  version: '11',
}.freeze

DEBIAN_12 = {
  platform: 'debian',
  version: '12',
}.freeze

ALL_PLATFORMS = [
  ALMA_8,
  ALMA_9,
  CENTOS_7,
  DEBIAN_11,
  DEBIAN_12,
].freeze

ALL_DEBIAN = [
  DEBIAN_11,
  DEBIAN_12,
].freeze

ALL_RHEL = [
  ALMA_8,
  ALMA_9,
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

ALMA_RESOURCES = [
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
