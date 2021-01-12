osl-repos
================

This cookbook manages the base, epel, extras, and updates repositories on Centos 7; and the appstream, base, elrepo,
epel, and powertools repositories on Centos 8. This cookbook imports these repositories and points them at the osuosl
repositories.

## Most Recent Release

```ruby
cookbook 'osl-repos', '~> 1.0.0'
```

## From Git

```ruby
cookbook 'osl-repos', git: 'git@github.com:osuosl-cookbooks/osl-repos.git'
```

## Repository

```
https://github.com/osuosl-cookbooks/osl-repos
```

## Recipes

- `osl-repos::centos`  - Configures and enables all repositories, with the exception of the 'elrepo' and 'epel' repos
- `osl-repos::elrepo`  - Configures and enables the 'elrepo' repository
- `osl-repos::epel`    - Configures and enables the 'epel' repository

## Resources

- `osl_repos_centos` - Manages and configures the appstream, base, extras, highavailability, powertools, and updates repositories
- `osl_repos_epel`   - Manages and configures the epel repository
- `osl_repos_elrepo` - Manages and configures the elrepo repository

### Actions:

| Action 	| Description                                                            	|
|--------	|------------------------------------------------------------------------	|
| add    	| Configures all repositories managed by a given resource                	|

### Properties:

Note: All repositories controlled by a resource will be installed and configured. These properties determine if said repos are **enabled**

| Resource  	| Property        	| Effect                     	      | Default  | Compatibility     |
|-----------	|-----------------  |---------------------------------	|--------  |-----------------  |
| centos 	    | appstream     	  | Enable the appstream repo   	    | True     | Centos 8          |
| centos 	    | base           	  | Enable the base repo   	          | True     | Centos 7 and 8    |
| centos      | extras            | Enable the extras repo   	        | True     | Centos 7 and 8    |
| centos   	  | highavailability  | Enable the highavailability repo  | False    | Centos 8          |
| centos   	  | powertools        | Enable the powertools repo   	    | True     | Centos 8          |
| centos      | updates        	  | Enable the updates repo   	  	  | True     | Centos 7          |
| epel    	  | epel           	  | Enable the epel repo   	  	      | True     | Centos 7 and 8    |
| elrepo  	  | elrepo         	  | Enable the elrepo repo   	  	    | True     | Centos 7 and 8    |


## Examples:

Configure the default suite of Centos repos by recipe:
```ruby
include_recipe 'osl-repos::centos'
```
Or resource:
```ruby
osl_repos_centos 'default'
```

Configure the EPEL repository via recipe:
```ruby
include_recipe 'osl-repos::epel'
```
Or resource:
```ruby
osl_repos_epel 'default'
```

Configure the ELRepo repository via recipe:
```ruby
include_recipe 'osl-repos::elrepo'
```
Or resource:
```ruby
osl_repos_elrepo 'default'
```

Disable or enable a specefic repo on creation (In this case PowerTools): 
```ruby
osl_repos_centos 'default' do
  powertools false
end
```

Disable or enable a specefic repo after including recipe or initializing resource: 
```ruby
edit resource(:osl_repos_centos, 'default') do
  powertools false
end
```

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
