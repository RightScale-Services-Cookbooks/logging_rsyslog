#
# Cookbook Name:: logging_rsyslog
#

rightscale_marker :begin

if (node[:logging_rsyslog])
  log "*** node[:logging_rsyslog] is defined"
else
  log "*** node[:logging_rsyslog] is undefined"
  node[:logging_rsyslog]={}
end


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

