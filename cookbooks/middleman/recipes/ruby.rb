#
# Cookbook:: middleman
# Recipe:: ruby
#
# Copyright:: 2017, The Authors, All Rights Reserved.
include_recipe 'runit'

user 'middleman' do
  comment 'middleman ruby user'
  home node['middleman']['home']
  gid 'users'
  action :create
end

git node['middleman']['install_dir'] do
  repository 'https://github.com/learnchef/middleman-blog.git' 
  reference 'master'
  user 'middleman'
  group 'users'
  action :sync
end

ruby_runtime 'middleman' do
  version '2.1'
end

bundle_install node['middleman']['install_dir'] do
  deployment true
  ruby 'middleman'
  user 'middleman'
end

runit_service "thin"

