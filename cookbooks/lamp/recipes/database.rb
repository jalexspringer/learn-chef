#
# Cookbook:: lamp
# Recipe:: database
#
# Copyright:: 2017, The Authors, All Rights Reserved.

# Load mysql passwords from data bag
passwords = data_bag_item('passwords', 'mysql')

# Config mysql client
mysql_client 'default' do
  action :create
end

# Config mysql service
mysql_service 'default' do
  initial_root_password passwords['root_password']
  action [:create, :start]
end
