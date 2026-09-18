osl-repos
================

This cookbook configures the package repositories used across OSL infrastructure, pointing them
at the OSU Open Source Lab mirrors wherever one is available.

On AlmaLinux it manages the distribution repositories (BaseOS, AppStream, extras, CRB/PowerTools,
HighAvailability, synergy, testing and nvidia) along with EPEL and ELRepo. On Debian it manages
`/etc/apt/sources.list` and unattended upgrades. Repositories that the OSL does not mirror
(HashiCorp, ELevate, RDO/OpenStack, CentOS Kmods) are configured against their upstreams.

## Repository:

```
https://github.com/osuosl-cookbooks/osl-repos
```

## Requirements:

### Platforms

- AlmaLinux 8, 9, 10
- Debian 12, 13
- Ubuntu 24.04

### Chef

- Chef Infra Client 16.0 or later

### Cookbooks

- [yum](https://github.com/sous-chefs/yum)
- [yum-almalinux](https://github.com/sous-chefs/yum-almalinux)
- [yum-elrepo](https://github.com/sous-chefs/yum-elrepo)
- [yum-epel](https://github.com/sous-chefs/yum-epel)

## Recipes:

| Recipe                 | Description                                                                | Platforms         |
|----------------------- |--------------------------------------------------------------------------- |------------------ |
| `osl-repos::alma`      | Configures the AlmaLinux distribution repositories                          | AlmaLinux         |
| `osl-repos::debian`    | Manages `/etc/apt/sources.list` and unattended upgrades                     | Debian            |
| `osl-repos::elevate`   | Configures the AlmaLinux 'ELevate' repository                               | AlmaLinux         |
| `osl-repos::elrepo`    | Configures the 'elrepo' repository                                          | AlmaLinux, x86_64 |
| `osl-repos::epel`      | Configures the 'epel' repository                                            | AlmaLinux         |
| `osl-repos::hashicorp` | Configures the upstream HashiCorp repository                                | all               |
| `osl-repos::openstack` | Configures the RDO, OSL OpenStack and CentOS NFV repositories               | AlmaLinux         |
| `osl-repos::oslrepo`   | Configures the legacy OSL repository                                        | all               |

## Resources:

| Resource                 | Description                                                             |
|------------------------- |------------------------------------------------------------------------ |
| `osl_repos_alma`         | Manages the AlmaLinux distribution repositories                          |
| `osl_repos_centos_kmods` | Manages the CentOS Kmods SIG repositories                                |
| `osl_repos_elrepo`       | Manages the elrepo repository using the `yum-elrepo` cookbook            |
| `osl_repos_epel`         | Manages the epel repository using the `yum-epel` cookbook                |
| `osl_repos_openstack`    | Manages the RDO, OSL OpenStack and CentOS NFV repositories               |

### Actions:

| Action  | Description                                              |
|-------- |--------------------------------------------------------- |
| add     | Configures all repositories managed by a given resource  |

### Properties:

Note: Unless called out below, all repositories controlled by a resource will be installed and configured. These properties determine if said repos are **enabled**

### osl_repos_alma:

| Property         | Effect                                          | Default | Compatibility  |
|----------------- |------------------------------------------------ |-------- |--------------- |
| appstream        | Enable the appstream repo                        | True    | Alma 8, 9, 10  |
| base             | Enable the base repo                             | True    | Alma 8, 9, 10  |
| extras           | Enable the extras repo                           | True    | Alma 8, 9, 10  |
| highavailability | Enable the highavailability repo                 | False   | Alma 8, 9, 10  |
| nvidia           | Manage and enable the nvidia repo                | False   | Alma 8, 9, 10  |
| powertools       | Enable the powertools (CRB on 9+) repo           | True    | Alma 8, 9, 10  |
| synergy          | Enable the synergy repo                          | False   | Alma 8, 9, 10  |
| testing          | Enable the testing repo                          | False   | Alma 8, 9, 10  |
| exclude          | Packages to exclude from every repo above        | []      | Alma 8, 9, 10  |

Note: unlike the others, `nvidia` is only declared when it is true, so the repo file is absent rather than disabled by default.

### osl_repos_centos_kmods:

| Property           | Effect                                    | Default | Compatibility  |
|------------------- |------------------------------------------ |-------- |--------------- |
| packages_main      | Manage the kmods packages-main repo        | True    | Alma 8, 9, 10  |
| packages_rebuild   | Manage the kmods packages-rebuild repo     | False   | Alma 8, 9, 10  |
| packages_userspace | Manage the kmods packages-userspace repo   | False   | Alma 8, 9, 10  |
| kernel_latest      | Manage the kmods kernel-latest repo        | False   | Alma 9, 10     |
| kernel_6_1         | Manage the kmods kernel-6.1 repo           | False   | Alma 8, 9      |
| kernel_6_6         | Manage the kmods kernel-6.6 repo           | False   | Alma 8, 9      |

### osl_repos_elrepo:

Note: elrepo is only published for x86_64, so this resource is a no-op on every other architecture. Unlike the other resources here, setting `elrepo` to false leaves the repository entirely unmanaged rather than writing a disabled repo file.

| Property  | Effect                                      | Default | Compatibility  |
|---------- |-------------------------------------------- |-------- |--------------- |
| elrepo    | Manage and enable the elrepo repo           | True    | Alma 8, 9, 10  |
| exclude   | Packages to exclude from the elrepo repo    | []      | Alma 8, 9, 10  |

### osl_repos_epel:

| Property      | Effect                                  | Default | Compatibility  |
|-------------- |---------------------------------------- |-------- |--------------- |
| epel          | Manage and enable the epel repo         | True    | Alma 8, 9, 10  |
| epel_enabled  | Enable the epel repo                    | True    | Alma 8, 9, 10  |
| exclude       | Packages to exclude from the epel repo  | []      | Alma 8, 9, 10  |

### osl_repos_openstack:

| Property  | Effect                        | Default                       | Compatibility  |
|---------- |------------------------------ |------------------------------ |--------------- |
| version   | OpenStack release to track    | yoga on 8/9, epoxy on 10      | Alma 8, 9, 10  |

## Examples:

Configure the EPEL repository:
```ruby
# via recipe
include_recipe 'osl-repos::epel'

# or resource
osl_repos_epel 'default'
```

Configure the ELRepo repository:
```ruby
# via recipe:
include_recipe 'osl-repos::elrepo'

# or resource
osl_repos_elrepo 'default'
```

Configure the default suite of Alma repos:
```ruby
# via recipe
include_recipe 'osl-repos::alma'

# or resource
osl_repos_alma 'default'
```

Disable or enable a specific repo on *creation* (In this case PowerTools):
```ruby
osl_repos_alma 'default' do
  powertools false
end
```

Disable or enable a specific repo *after including* the recipe or initializing the resource:
```ruby
edit_resource(:osl_repos_alma, 'default') do
  powertools false
end
```

Exclude packages from a repository:
```ruby
osl_repos_epel 'default' do
  exclude %w(postgresql postgresql-*)
end
```

### Multiple declarations:

`osl_repos_epel` and `osl_repos_elrepo` may be declared more than once in a run - a wrapper
cookbook can ask for epel without knowing whether something else already did. Those
declarations cooperate on a single repo rather than the last one silently winning:

```ruby
include_recipe 'osl-repos::epel'

osl_repos_epel 'postgres' do
  exclude %w(postgresql)
end
# => epel.repo is written once, with exclude=postgresql
```

The merge rules are order independent, so the result does not depend on which declaration
happens to come first:

- `exclude` is the **union** of every declaration's list
- epel is enabled only if **no** declaration set `epel` or `epel_enabled` to false

Because of this, a later declaration cannot drop an exclude or re-enable epel that an
earlier one turned off. Use `edit_resource` on the declaration itself for that.

## Testing:

Unit tests run under ChefSpec, and cookstyle enforces the lint rules:

```
chef exec rspec
chef exec cookstyle
```

Integration tests run under Test Kitchen against Vagrant by default, or Docker via the
dokken config:

```
kitchen list all
KITCHEN_LOCAL_YAML=kitchen.dokken.yml kitchen test epel-almalinux-9
```

Note: Test Kitchen runs with `enforce_idempotency`, so every suite converges twice and fails
if the second converge changes anything.

## Contributing:

1. Fork the repository on Github
2. Create a named feature branch (like `username/add_component_x`)
3. Write tests for your change
4. Write your change
5. Run the tests, ensuring they all pass
6. Submit a Pull Request using Github

## License and Authors:

- Author:: Oregon State University <chef@osuosl.org>

```text
Copyright:: 2020-2026, Oregon State University

Licensed under the Apache License, Version 2.0 (the "License");
you may not use this file except in compliance with the License.
You may obtain a copy of the License at

    http://www.apache.org/licenses/LICENSE-2.0

Unless required by applicable law or agreed to in writing, software
distributed under the License is distributed on an "AS IS" BASIS,
WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
See the License for the specific language governing permissions and
limitations under the License.
```
