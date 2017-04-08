#
# Cookbook:: lamp
# Recipe:: web
#
# Copyright:: 2017, The Authors, All Rights Reserved.

# Create the document root directory.
directory node['lamp']['web']['document_root'] do
  recursive true
end

# Site config
httpd_config 'default' do
  source 'default.conf.erb'
end

# Install apache and start
httpd_service 'default' do
  mpm 'prefork'
  action [:create, :start]
  subscribes :restart, 'httpd_config[default]'
end

# PHP Stuff Starts Here
httpd_module 'php5' do
  instance 'default'
end

package 'php5-mysql' do
  action :install
  notifies :restart, 'httpd_service[default]'
end
