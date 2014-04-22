#
# Cookbook Name:: logging_rsyslog
#

rightscale_marker :begin

log "*** in recipe: logging_rsyslog::zip_logs_schedule_enable, creating /etc/syslog-zip-logs.sh"

# Compress *.log files not changed in more than 24 hours
template "/etc/syslog-zip-logs.sh" do
  source "syslog-zip-logs.erb"
  mode 0755
  variables(
    :path => "#{node[:logging_rsyslog][:logs_location]}"
  )
end

cron "rs_syslog_zip" do
  minute "15"
  hour "0"
  command "/etc/syslog-zip-logs.sh 2>&1 >> /var/log/rs_syslog_zip.log"
  action :create
end

rightscale_marker :end

