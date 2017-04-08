#
# Cookbook:: lamp_customers
# Recipe:: default
#
# Copyright:: 2017, The Authors, All Rights Reserved.

include_recipe 'lamp::default'

passwords = data_bag_item('passwords', 'mysql')

# Create a path to SQL file in cache
create_tables_script_path = ::File.join(Chef::Config[:file_cache_path], 'create_tables.sql')

# Get the creation script
cookbook_file create_tables_script_path do
  source 'create-tables.sql'
end

# Seed the database with table and test data
execute "initialize #{node['lamp']['database']['dbname']} database" do
  command "mysql -h 127.0.0.1 -u #{node['lamp']['database']['admin_username']} -p#{passwords['admin_password']} -D #{node['lamp']['database']['dbname']} < #{create_tables_script_path}"
  not_if  "mysql -h 127.0.0.1 -u #{node['lamp']['database']['admin_username']} -p#{passwords['admin_password']} -D #{node['lamp']['database']['dbname']} -e 'describe customers;'"
end

# Write the homepage
template "#{node['lamp']['web']['document_root']}/index.php" do
  source "index.php.erb"
  variables(
    servername: '127.0.0.1',
    admin_password: passwords['admin_password']
  )
end
