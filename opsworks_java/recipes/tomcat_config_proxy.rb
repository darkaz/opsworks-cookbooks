template 'tomcat server reconfiguration' do
  path ::File.join(node['opsworks_java']['tomcat']['catalina_base_dir'], 'server.xml')
  source 'server.xml.erb'
  owner 'root'
  group 'root'
  mode 0644
  backup false
  notifies :restart, 'service[tomcat]'
end

template 'apache2.conf replace' do
  case node[:platform_family]
  when 'rhel'
    path "#{node[:apache][:dir]}/conf/httpd.conf"
  when 'debian'
    path "#{node[:apache][:dir]}/apache2.conf"
  end
  source 'apache2.conf.erb'
  owner 'root'
  group 'root'
  mode 0644
  notifies :run, resources(:bash => 'logdir_existence_and_restart_apache2')
end
