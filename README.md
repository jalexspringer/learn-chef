# Exercises from the Chef workshop
## Middleman - 104.196.3.233

### setup
Workstation: Centos7 vagrant box

Chef Server: Hosted Chef

Node: Ubuntu 12.04 instance on Google Cloud Compute Engine

### steps

1. Install ChefDK on vagrant box (workstation)
2. Configure Chef Server, get keys and create knife config on workstation
3. Generate cookbook 'middleman' on workstation
7. Write up that default, web, ruby recipes, testing in Test Kitchen along the way.

### web recipe - httpd
1. Install httpd modules - proxy, proxy_http, rewrite
2. Place config
3. Start/restart service
### ruby recipe
1. Install packages to build from source
2. Download and install ruby 2.1.3 from source - install from source code comes from the implementation here: https://github.com/onetimesecret/onetimesecret-cookbook/blob/master/recipes/ruby.rb - thanks JJ!
3. Gem package to install bundler
4. Clone repository
5. bundle install inside middleman-blog repository
6. Install thin, configure defaults, place config files. NOTE: Instructions are incorrect here and state that blog.conf needs to go where blog.yml should be.

### notes
- User permission issues plagued me on this. Ended up using the ubuntu user that my gcloud login defaulted to. Need to create a middleman user for security reasons - most likely add ALL permissions to /etc/sudoer.d/ to make it smoother.
- Cheating doesn't work :) - install the ruby package brings a 1.* version down and plays havoc with the bundle install. Alternatives - add the ppa and then download the right version. But why do that when you can build from source :p

## AwesomeApplianceRepair - 104.196.210.253

### setup
Workstation: Centos7 vagrant box

Chef Server: Hosted Chef

Node: Ubuntu 12.04 instance on Google Cloud Compute Engine

### steps

1. Using the same workstation and Chef Server organization as above.
3. Generate cookbook 'aar' on workstation
4. Add dependencies to metadata - in this case I built from the lamp(ython!) cookbook I built in the tuts
5. Update attributes to correct db name, update testing data bag with secret key
6. Add templates - I turned the config creation script into simple python erb template and used data bag values to populate. SQL creation script goes right into files.
7. Write up that default recipe, testing in Test Kitchen along the way.

### default recipe
1. Install packages (lamp recipe manages periodic apt-get updates, as well as getting the server and database running)
2. Pip install flask
3. Git export the repository, move the app to /var/www
4. Change ownership to www-data. This feels like something I should be able to do with a resource...
5. Generate config file - see notes
6. Drop sql script into the Chef cache file. Lets chef clean up after itself?
7. Execute script unless the customer table already exists

### notes
- I chose to use the git resource rather than download and extract. Seems like this is more agile and can be used to check for updates to deploy. Working on the :nothing/notify flow, the File.exists guard seems inelegant and prevents the point made in the last sentence from meaning anything, but I also don't want to overwrite the config file in AAR after it is created, in the event I do implement the random genration from a couple of points down.
- Data bag problems. Everything works great in test kitchen with the testing data bag. Not so hot in production with the actual bag. The values are populating correctly... still investigating.
- The current setup uses the data bags and therefore does not randomly generate the passwords like the install script. Feature not bug? Ideally I figure out how to automate the creation of data bag values on first run as part of the cookbook.


## Tomcat - In progress
### setup
Workstation: Centos7 vagrant box

Chef Server: Hosted Chef

Node: Centos7 instance on Google Cloud Compute Engine

### steps

1. Install ChefDK on vagrant box (workstation)
2. Configure Chef Server, get keys and create knife config on workstation
3. Generate cookbook 'tomcat' on workstation - add first step of config (OpenJDK install)
4. Spin up GCE instance with Centos7 (node)
5. knife bootstrap on workstation with GCE ip and ssh keys, run-list[tomcat]
6. Confirm new node in knife node list. Confirm JDK installation on node.
7. Write up that default recipe, testing in Test Kitchen along the way

### default recipe
1. OpenJDK - package
2. User and groups
	- The instructions do not list creating the tomcat user or group, so I added that step in.
3. Download tomcat - remote_file (See notes)
4. Extract files - bash
5. Change permissions
	- Spent a considerable amount of time with the file resource. Eventually just used bash.
6. Add systemd unit file
7. Reload, start, and enable systemd services

### testing
TODO: 'curl localhost:8080' to confirm setup

TODO: confirm external access?

### notes
- Getting the tomcat file (remote_file) does not currently account for changes in version, location, etc. TODO Use attributes to define these variables and make it easier to maintain this.
