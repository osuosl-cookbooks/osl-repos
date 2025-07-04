# osl-repos CHANGELOG

This file is used to list changes made in each version of the osl-repos cookbook.

5.9.0 (2025-07-03)
------------------
- AlmaLinux 10 support

5.8.2 (2025-04-23)
------------------
- Update to yum-elrepo 2.3.0 to get correct gpg keys

5.8.1 (2025-02-14)
------------------
- Use correct gpgkey on AlmaLinux 9 for OpenStack repos

5.8.0 (2024-12-19)
------------------
- OpenStack Yoga

5.7.0 (2024-12-11)
------------------
- OpenStack Xena

5.6.0 (2024-12-09)
------------------
- OpenStack Wallaby

5.5.0 (2024-12-04)
------------------
- OpenStack Victoria

5.4.0 (2024-11-25)
------------------
- Switch to OpenStack Ussuri Release

5.3.0 (2024-10-25)
------------------
- Add property for using synergy repo in AlmaLinux

5.2.2 (2024-10-14)
------------------
- Add OSL-openstack repo globally

5.2.1 (2024-10-14)
------------------
- Rename POWER10 specific repo to it's own repo

5.2.0 (2024-10-11)
------------------
- Add osl_repos_centos_kmods resource

5.1.0 (2024-08-14)
------------------
- Add debian recipe to centrally manage debian OS repos

5.0.2 (2024-07-26)
------------------
- Add support for Ubuntu

5.0.1 (2024-07-25)
------------------
- Add Debian oslrepo

5.0.0 (2024-07-16)
------------------
- Remove support for CentOS 7

4.7.2 (2024-05-03)
------------------
- Remove support for Debian 11

4.7.1 (2024-03-13)
------------------
- Set module_hotfixes so qemu-kvm packages work properly against appstream

4.7.0 (2024-03-12)
------------------
- Add support for POWER10 on OpenStack

4.6.1 (2023-12-19)
------------------
- Update defaults to OpenStack Train for EL7

4.6.0 (2023-12-13)
------------------
- Create openstack recipe

4.5.1 (2023-12-06)
------------------
- Fix url for ppc64le/aarch64

4.5.0 (2023-12-06)
------------------
- Create osl_repos_openstack resource

4.4.0 (2023-10-04)
------------------
- Add scl property to osl_repos_centos

4.3.1 (2023-08-30)
------------------
- Set the description for the Hashicorp Yum repo

4.3.0 (2023-08-30)
------------------
- Hashicorp repository

4.2.1 (2023-05-31)
------------------
- Bump to yum-almalinux 1.1.0

4.2.0 (2023-05-30)
------------------
- ELevate repository recipe

4.1.0 (2023-05-26)
------------------
- Add Almalinux 9 support

4.0.0 (2023-05-04)
------------------
- Remove references to CentOS Stream 8

3.1.0 (2023-04-18)
------------------
- Bump to latest releases of upstream cookbooks

3.0.0 (2023-02-02)
------------------
- Add AlmaLinux support

2.2.0 (2022-08-26)
------------------
- Migrate base::oslrepo into this cookbook

2.1.0 (2022-02-01)
------------------
- Add exclude property to resources

2.0.2 (2022-01-14)
------------------
- Enable EPEL on s390x

2.0.1 (2022-01-11)
------------------
- Update yum pin to 7.3

2.0.0 (2021-11-24)
------------------
- CentOS Stream 8 support

1.3.0 (2021-10-05)
------------------
- Update `yum` version pin to support Chef 17

1.2.0 (2021-06-16)
------------------
- Set unified_mode for custom resources

1.1.2 (2021-04-28)
------------------
- Use declare_resource correctly

1.1.1 (2021-04-27)
------------------
- Fix issues with yum_repository resources not working

1.1.0 (2021-04-07)
------------------
- Update Chef dependency to >= 16

1.0.3 (2021-02-19)
------------------
- Directly use yum_globalconfig resource

1.0.2 (2021-02-17)
------------------
- Automatically remove pkg deps

1.0.1 (2021-02-04)
------------------
- Use edit_resource on yum repos if they exist

1.0.0 (2021-01-26)
------------------
- Inital PR 

## 0.1.0

- Initial release
