#
# Cookbook:: middleman
# Recipe:: web
#
# Copyright:: 2017, The Authors, All Rights Reserved.

httpd_module 'proxy' do
  instance 'default'
end

httpd_module 'proxy_http' do
  instance 'default'
end

httpd_module 'rewrite' do
  instance 'default'
end

httpd_config 'default' do
  source 'blog.conf.erb'
end

httpd_service 'default' do
  action [:create, :start]
  subscribes :restart, 'httpd_config[default]'
end
