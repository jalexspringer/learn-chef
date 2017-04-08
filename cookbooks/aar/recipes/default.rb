#
# Cookbook:: lamp_customers
# Recipe:: default
#
# Copyright:: 2017, The Authors, All Rights Reserved.

include_recipe 'lamp::default'

# Flask and python
package [ 'unzip', 'libapache2-mod-wsgi', 'python-pip', 'python-mysqldb', 'git' ]

execute 'install-flask' do
  command <<-EOF
    pip install flask
  EOF
end

# Get the AAR files
git 'tmp/Awesome-Appliance-Repair' do
  action :export
  repository 'https://github.com/colincam/Awesome-Appliance-Repair.git'
  not_if { ::File.exist?('/var/www/AAR') }
end

bash 'mv AAR' do
  cwd '/tmp/Awesome-Appliance-Repair'
  code <<-EOH
    mv AAR /var/www/
  EOH
end

# Site config
httpd_config 'AAR-apache' do
  source 'aar.conf.erb'
end

# Database config
passwords = data_bag_item('passwords', 'mysql')

# Create a path to SQL file in cache
create_tables_script_path = ::File.join(Chef::Config[:file_cache_path], 'make_AARdb.sql')

# Get the creation script
cookbook_file create_tables_script_path do
  source 'make_AARdb.sql'
end

# Seed the database with table and test data
execute "initialize #{node['lamp']['database']['dbname']} database" do
  command "mysql -h 127.0.0.1 -u #{node['lamp']['database']['admin_username']} -p#{passwords['admin_password']} -D #{node['lamp']['database']['dbname']} < #{create_tables_script_path}"
  not_if  "mysql -h 127.0.0.1 -u #{node['lamp']['database']['admin_username']} -p#{passwords['admin_password']} -D #{node['lamp']['database']['dbname']} -e 'describe customers;'"
end
