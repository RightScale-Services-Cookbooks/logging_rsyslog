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

    rsyslog_pid=`pgrep rsyslog || true`
    echo " *** rsyslogd running with pid $rsyslog_pid"

    if ! test "$rsyslog_pid" = "" ; then
      rsyslog_user=`ps h -p $rsyslog_pid -o user`
      if test "$rsyslog_user" = "" ; then
        rsyslog_user="root"
      fi
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

