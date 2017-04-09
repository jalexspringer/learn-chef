#
# Cookbook:: lamp
# Recipe:: web
#
# Copyright:: 2017, The Authors, All Rights Reserved.

# Create the document root directory.
# directory node['lamp']['web']['document_root'] do
#   recursive true
# end

# Site config
templates '/etc/apache2/sites-enabled/AAR-apache.conf' do
  source 'AAR-apache.conf.erb'
end

httpd_config 'default' do
  # source 'default.conf.erb'
  source 'AAR-apache.conf.erb'
end

# Install apache and start
httpd_service 'default' do
  mpm 'prefork'
  action [:create, :start]
  subscribes :restart, 'httpd_config[default]'
end

httpd_module 'wsgi' do
  instance 'default'
end

# package 'php5-mysql' do
#   action :install
#   notifies :restart, 'httpd_service[default]'
# end
