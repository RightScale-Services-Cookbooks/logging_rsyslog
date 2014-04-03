#
# Cookbook Name:: logging_rsyslog
#

rightscale_marker :begin

log "*** in recipe: logging_rsyslog::add_custom_templates"

if (!node[:logging_rsyslog])
  #to avoid exception when node[:logging_rsyslog][:allowed_senders] is undefined
  node[:logging_rsyslog]={}
end


# Deploy custom filters and restart service
template "/etc/rsyslog.d/20-custom-templates.conf" do
  source "rsyslog-custom-templates.erb"
  mode 0644  
  variables(
    :path => "#{node[:logging_rsyslog][:logs_location]}",
    :allowed => "#{node[:logging_rsyslog][:allowed_senders]}"
  )
end

service "rsyslog" do
  action :restart
end

rightscale_marker :end

