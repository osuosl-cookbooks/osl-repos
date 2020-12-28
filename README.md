# osl-repos

  This cookbook manages the base, epel, extras, and updates repositories on Centos 7; and the appstream, base, elrepo,
  epel, and powertools repositories on Centos 8. This cookbook imports these repositories and points them at the osuosl
  repositories.
## Requirements

 - Chef/Cinc 15+
 - Centos 7+
### Platforms

- CentOS 7+

### Cookbooks

 - yum
 - yum-centos
 - yum-elrepo
 - yum-epel
## Attributes

  None

## Resources

  osl_repos_centos

  Properties

  Note: The 'appstream', 'elrepo', and 'powertools' related attributes are only relevant to Centos 8, and the 'updates' related
  attributes are only relevant to Centos 7.

 - appstream:              indicates if the appstream repository is managed
 - base:                   indicates if the base repository is managed
 - elrepo:                 indicates if the elrepo repository is managed
 - epel:                   indicates if the epel repository is managed
 - extras:                 indicates if the appstream repository is managed
 - powertools:             indicates if the powertools repository is managed
 - updates:                indicates if the updates repository is managed


 - appstream_enabled:      indicates if the appstream repository is enabled
 - base_enabled:           indicates if the base repository is enabled
 - elrepo_enabled:         indicates if the elrepo repository is enabled
 - epel_enabled:           indicates if the epel repository is enabled
 - extras_enabled:         indicates if the appstream repository is enabled
 - powertools_enabled:     indicates if the powertools repository is enabled
 - updates_enabled:        indicates if the updates repository is enabled

## Recipes

 - osl-repos::default   configures and enables all repositories managed by this cookbook
 - osl-repos::centos    configures and enables all repositories, with the exception of the 'elrepo' and 'epel' repos
 - osl-repos::elrepo    configures and enables the 'elrepo' repository
 - osl-repos::epel      configures and enables the 'epel' repository
## Contributing

1. Fork the repository on Github
1. Create a named feature branch (like `username/add_component_x`)
1. Write tests for your change
1. Write your change
1. Run the tests, ensuring they all pass
1. Submit a Pull Request using Github

## License and Authors

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
