#
# Cookbook Name:: logging_rsyslog
#

rightscale_marker :begin

# Deploy custom filters and restart service
template "/etc/rsyslog.d/20-custom-templates.conf" do
  source "rsyslog-custom-templates.erb"
  mode 0644  
  variables(
    :path => "/mnt/ephemeral/syslog",
    :allowed => "#{node[:logging_rsyslog][:allowed_senders]}"
  )
end

service "rsyslog" do
  action :restart
end

rightscale_marker :end

