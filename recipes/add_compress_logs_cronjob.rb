#
# Cookbook Name:: logging_rsyslog
#

rightscale_marker :begin

# Compress *.log files not changed in more than 24 hours
template "/etc/cron.hourly/syslog-zip-logs" do
  source "syslog-zip-logs.erb"
  mode 0755
  variables(
    :path => "/mnt/ephemeral/syslog"
  )
end

rightscale_marker :end

