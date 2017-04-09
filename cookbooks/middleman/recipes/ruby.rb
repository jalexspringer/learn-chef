#
# Cookbook:: middleman
# Recipe:: ruby
#
# Copyright:: 2017, The Authors, All Rights Reserved.
include_recipe 'runit'

package ['build-essential', 'libssl-dev', 'libyaml-dev', 'libreadline-dev', 'openssl', 'curl', 'git-core', 'zlib1g-dev', 'bison', 'libxml2-dev', 'libxslt1-dev', 'libcurl4-openssl-dev', 'nodejs', 'libsqlite3-dev', 'sqlite3']

remote_file "/tmp/ruby-2.1.3.tar.gz" do
  source "ftp://ftp.ruby-lang.org/pub/ruby/2.1/ruby-2.1.3.tar.gz"
  owner "root"
  group "root"
  mode "0644"
  action :create
end

bash "build ruby" do
  user "root"
  cwd "/tmp"
  creates "/usr/bin/gem"
  code <<-EOH
    STATUS=0
    tar xvzf ruby-2.1.3.tar.gz || STATUS=1
    cd ruby-2.1.3 || STATUS=1
     ./configure && make || STATUS=1
     make install || STATUS=1
    exit $STATUS
  EOH
end

# Install Bundler
gem_package 'bundler'

# Create middleman user
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

bash 'bundle_install' do
  user 'middleman'
  cwd '/home/middleman/middleman-blog'
  code <<-EOH
    bundle install --frozen --deployment --without=dev || STATUS=1
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
