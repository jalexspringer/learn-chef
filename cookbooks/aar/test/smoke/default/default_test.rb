# # encoding: utf-8

# Inspec test for recipe lamp_customers::default

# The Inspec reference, with examples and extensive documentation, can be
# found at http://inspec.io/docs/reference/resources/

describe mysql_conf('/etc/mysql-default/my.cnf').params('mysqld') do
  its('port') { should eq '3306' }
  its('socket') { should eq '/run/mysql-default/mysqld.sock' }
end

describe port 3306 do
  it { should be_listening }
  its('protocols') { should include('tcp') }
end

describe command("mysql -h 127.0.0.1 -uroot -pfakerootpassword -s -e 'show databases;'") do
  its('stdout') { should match(/mysql/) }
end

describe package 'apache2' do
  it { should be_installed }
end

describe service 'apache2-default' do
  it { should be_enabled }
  it { should be_running }
end

describe command 'wget -qSO- --spider localhost' do
  its('stderr') { should match %r{HTTP/1\.1 200 OK} }
end

describe port 80 do
  it { should be_listening }
end
