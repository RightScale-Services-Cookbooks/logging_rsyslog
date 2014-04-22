#
# Cookbook Name:: logging_rsyslog
#

rightscale_marker :begin

log "*** in recipe: logging_rsyslog::add_custom_templates"

if (!node[:logging_rsyslog])
  #to avoid exception when node[:logging_rsyslog][:allowed_senders] is undefined
  node[:logging_rsyslog]={}
end

bash "Setting up the logs location" do
  flags "-ex"
  user "root"
  cwd "/tmp"
  code <<-EOH
    echo " *** Creating #{node[:logging_rsyslog][:logs_location]}"
    mkdir -p #{node[:logging_rsyslog][:logs_location]}
    
    #echo " *** running ps aux | grep syslog"
    #ps aux | grep syslog

    #echo " *** running ps aux | grep rsyslog | grep -v grep | tail -1"
    #ps aux | grep rsyslog | grep -v grep | tail -1
  
    rsyslog_user=`ps aux | grep rsyslog | grep -v grep | tail -1 | awk '{print $1}' || true`
    if ! test "$rsyslog_user" = "" ; then
      echo " *** Setting owner for #{node[:logging_rsyslog][:logs_location]} to $rsyslog_user"
      chown $rsyslog_user #{node[:logging_rsyslog][:logs_location]}
    fi
  EOH
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

