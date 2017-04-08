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

# Create mysql database instance
mysql_conn_info = {
  :host     => '127.0.0.1',
  :username => 'root',
  :password => passwords['root_password']
}

mysql_database node['lamp']['database']['dbname'] do
  connection mysql_conn_info
  action :create
end

mysql_database_user 'disenfranchised' do
  connection mysql_conn_info
  password   passwords['admin_password']
  database_name node['lamp']['database']['dbname']
  host mysql_conn_info['host']
  action [:create, :grant]
end
