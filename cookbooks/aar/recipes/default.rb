#
# Cookbook:: lamp_customers
# Recipe:: default
#
# Copyright:: 2017, The Authors, All Rights Reserved.

include_recipe 'lamp::default'

passwords = data_bag_item('passwords', 'mysql')

# Flask and python
package [ 'libapache2-mod-wsgi', 'python-pip', 'python-mysqldb', 'git' ]

execute 'install-flask' do
  command <<-EOF
    pip install flask
  EOF
end

# Get the AAR files
git '/tmp/Awesome-Appliance-Repair' do
  action :export
  repository 'https://github.com/colincam/Awesome-Appliance-Repair.git'
  # TODO Figure this thing out
  # notifies :run, 'bash[mv_ARR]', :immediately
  not_if {File.exists?('/var/www/AAR')}
end

bash 'mv_AAR' do
  cwd '/tmp/Awesome-Appliance-Repair'
  code <<-EOH
    mv AAR /var/www/
  EOH
  action :nothing
  not_if {File.exists?('/var/www/AAR')}
end

template '/var/www/AAR/AAR_config.py' do
  source 'create_config.py.erb'
  variables(
    admin_pass: passwords['admin_password'],
    secret_key: passwords['secret_key']
  )
end

# Site config
# httpd_config 'default' do
#   source 'AAR-apache.conf.erb'
# end

# httpd_service 'default' do
#   action [:create, :start]
#   subscribes :restart, 'httpd_config[default]'
# end

# Database config

# Create a path to SQL file in cache
create_tables_script_path = ::File.join(Chef::Config[:file_cache_path], 'make_AARdb.sql')

# Get the creation script
cookbook_file create_tables_script_path do
  source 'make_AARdb.sql'
end

# Seed the database with table and test data
execute "initialize #{node['lamp']['database']['dbname']} database" do
  command "mysql -h 127.0.0.1 -u #{node['lamp']['database']['admin_username']} -p#{passwords['admin_password']} -D #{node['lamp']['database']['dbname']} < #{create_tables_script_path}"
  not_if  "mysql -h 127.0.0.1 -u #{node['lamp']['database']['admin_username']} -p#{passwords['admin_password']} -D #{node['lamp']['database']['dbname']} -e 'describe customer;'"
end
