#
# Cookbook:: middleman
# Recipe:: ruby
#
# Copyright:: 2017, The Authors, All Rights Reserved.
include_recipe 'runit'

package ['git', 'ruby', 'ruby-dev']

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

# file "#node['middleman']['install_dir']/Gemfile.lock" do
#   user 'middleman'
#   action :delete
# end

# bundle_install node['middleman']['install_dir'] do
#   deployment false
#   user 'middleman'
# end

# Install Bundler
gem_package 'bundler'

bash 'bundle_install' do
  user 'middleman'
  cwd '/home/middleman/middleman-blog'
  code <<-EOH
    sudo bundle update
    sudo bundle install
    sudo thin install
    sudo /usr/sbin/update-rc.d -f thin defaults
  EOH
end

template '/etc/thin/blog.conf' do
  source 'blog.conf.erb'
  variables(
    project_install_directory:  node['middleman']['install_dir']
  )
end
template '/etc/init.d/thin' do
  source 'thin.erb'
  variables(
    home_directory:  node['middleman']['home']
  )
end

runit_service "thin"
