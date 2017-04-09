#
# Cookbook:: mongodb
# Recipe:: default
#
# Copyright:: 2017, Alex Springer, All Rights Reserved.

# Node attribute not listed in documentation, but found it here: https://gist.github.com/alvarobp/1122327
if node['kernel']['machine'] == 'x86_64'
  configfile = 'mongodb64.repo'
else
  configfile = 'mongodb32.repo'
end

cookbook_file '/etc/yum.repos.d/mongodb.repo' do
  source configfile
end

package 'mongodb-org'

service 'mongod' do
  action [:enable, :start]
end

bash 'check_start_on_reboot' do
  code <<-EOH
    sudo chkconfig mongod on
  EOH
end
