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

DEBIAN_12 = {
  platform: 'debian',
  version: '12',
}.freeze

UBUNTU_2404 = {
  platform: 'ubuntu',
  version: '24.04',
}.freeze

ALL_PLATFORMS = [
  ALMA_8,
  ALMA_9,
  DEBIAN_12,
  UBUNTU_2404,
].freeze

ALL_DEBIAN = [
  DEBIAN_12,
  UBUNTU_2404,
].freeze

ALL_RHEL = [
  ALMA_8,
  ALMA_9,
].freeze

ALL_RESOURCES = [
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
