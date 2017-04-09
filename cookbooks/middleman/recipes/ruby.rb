#
# Cookbook:: middleman
# Recipe:: ruby
#
# Copyright:: 2017, The Authors, All Rights Reserved.
include_recipe 'runit'

package 'git'

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

file '#node['middleman']['install_dir']/Gemfile.lock' do
  action :delete
end

bundle_install node['middleman']['install_dir'] do
  deployment false
  user 'middleman'
end

runit_service "thin"

