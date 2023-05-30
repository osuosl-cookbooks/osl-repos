osl-repos
================

This cookbook manages the base, epel, extras, and updates repositories on CentOS 7; and the appstream, base, highavailability, and powertools repositories on AlmaLinux 8. This cookbook imports these repositories and points them at the osuosl
repositories.

## Repository:

```
https://github.com/osuosl-cookbooks/osl-repos
```

## Recipes:

- `osl-repos::centos`  - Configures and enables all repositories, with the exception of the 'elrepo' and 'epel' repos
- `osl-repos::elevate` - Configures and enables the 'elevate' repository
- `osl-repos::elrepo`  - Configures and enables the 'elrepo' repository
- `osl-repos::epel`    - Configures and enables the 'epel' repository
- `osl-repos::oslrepo` - Configures and enables the 'oslrepo' repository (legacy OSL repo)

## Resources:

- `osl_repos_centos` - Manages and configures the appstream, base, extras, highavailability, powertools, and updates repositories using the `yum-centos` cookbook
- `osl_repos_elrepo` - Manages and configures the elrepo repository using the `yum-epel` cookbook
- `osl_repos_epel`   - Manages and configures the epel repository using the `yum-elrepo` cookbook
- `osl_repos_alma`   - Manages and configures the base, extras, appstream, highavailability, powertools

### Actions:

| Action   | Description                                                              |
|--------  |------------------------------------------------------------------------  |
| add      | Configures all repositories managed by a given resource                  |

### Properties:

Note: All repositories controlled by a resource will be installed and configured. These properties determine if said repos are **enabled**

### osl_repos_centos:
| Property          | Effect                            | Default  | Compatibility     |
|-----------------  |---------------------------------  |--------  |-----------------  |
| appstream         | Enable the appstream repo         | True     | Alma 8            |
| base              | Enable the base repo              | True     | Centos 7 & Alma 8 |
| extras            | Enable the extras repo            | True     | Centos 7 & Alma 8 |
| highavailability  | Enable the highavailability repo  | False    | Alma 8            |
| powertools        | Enable the powertools repo        | True     | Alma 8            |
| updates           | Enable the updates repo           | True     | Centos 7          |

### osl_repos_elrepo:
| Property          | Effect                            | Default  | Compatibility     |
|-----------------  |---------------------------------  |--------  |-----------------  |
| elrepo            | Enable the elrepo repo            | True     | Centos 7 & Alma 8 |

### osl_repos_epel:
| Resource    | Property          | Effect                            | Default  | Compatibility     |
|-----------  |-----------------  |---------------------------------  |--------  |-----------------  |
| epel        | epel              | Enable the epel repo              | True     | Centos 7 & Alma 8 |
## Examples:

Configure the default suite of Centos repos:
```ruby
# via recipe
include_recipe 'osl-repos::centos'

# or resource
osl_repos_centos 'default'
```

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
osl_repos_centos 'default' do
  powertools false
end
```

Disable or enable a specific repo *after including* the recipe or initializing the resource:
```ruby
edit resource(:osl_repos_centos, 'default') do
  powertools false
end
```

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
Copyright:: 2020, Oregon State University

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
