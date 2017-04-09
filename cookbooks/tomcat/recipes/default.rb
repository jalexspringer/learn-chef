#
# Cookbook:: tomcat
# Recipe:: default
#
# Copyright:: 2017, The Authors, All Rights Reserved.
#

# Install OpenJDK
yum_package 'java-1.7.0-openjdk-devel'

# Create user and group
group 'chef'
group 'tomcat'
user 'chef' do
  gid 'chef'
end
user 'tomcat' do
  gid 'tomcat'
end

# Download and extract Tomcat binary
remote_file '/tmp/tomcat.tar.gz' do
  source 'https://archive.apache.org/dist/tomcat/tomcat-8/v8.0.9/bin/apache-tomcat-8.0.9.tar.gz'
end

bash 'extract_module' do
  cwd '/tmp'
  code <<-EOH
    mkdir -p /opt/tomcat
    tar xvf tomcat.tar.gz -C /opt/tomcat --strip-components=1
    EOH
  not_if { ::File.exist?('/opt/tomcat') }
end

# Permissions
bash 'change_permissions' do
  cwd '/opt/tomcat'
  code <<-EOH
    sudo chgrp -R tomcat conf
    sudo chmod g+rwx conf
    sudo chmod g+r conf/*
    sudo chown -R tomcat webapps/ work/ temp/ logs/
  EOH
end

# Permission changes using resources. Not functioning currently.
#directory '/opt/tomcat/conf' do
#  group 'tomcat'
#  recursive true
#  mode '777'
#end
 
# directory '/opt/tomcat/conf/*' do
#   mode '777'
# end

# directory '/opt/tomcat' do
#   group 'tomcat'
#   mode '777'
# end
# 
# %w[ /webapps /work /temp /logs ].each do |path|
#   directory '/opt/tomcat/#{path}' do
#     owner 'tomcat'
#   end
# end

# Systemd Unit File
template '/etc/systemd/system/tomcat.service' do
  source 'tomcat.service.erb'
end
# Reload, enable, and start service
execute 'daemon-reload' do
  command "systemctl daemon-reload"
end

service 'tomcat' do
  action [:start, :enable]
end
