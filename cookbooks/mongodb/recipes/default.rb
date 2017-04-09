#
# Cookbook:: mongodb
# Recipe:: default
#
# Copyright:: 2017, Alex Springer, All Rights Reserved.

cookbook_file '/etc/yum.repos.d/mongodb.repo' do
  source 'mongodb.repo'
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
