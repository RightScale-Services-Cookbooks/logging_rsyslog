#
# Cookbook Name:: logging_rsyslog
#

rightscale_marker :begin

log "*** in recipe: logging_rsyslog::add_compress_logs_cronjob, creating /etc/cron.hourly/syslog-zip-logs"

# Compress *.log files not changed in more than 24 hours
template "/etc/cron.hourly/syslog-zip-logs" do
  source "syslog-zip-logs.erb"
  mode 0755
  variables(
    :path => "#{node[:logging_rsyslog][:logs_location]}"
  )
end

rightscale_marker :end

