#
# Cookbook Name:: logging_rsyslog
#

rightscale_marker :begin

# Compress *.log files not changed in more than 24 hours
template "/etc/cron.hourly/syslog-bzip2" do
  source "syslog-bzip2.erb"
  mode 0755
  variables(
    :path => "/mnt/ephemeral/syslog"
  )
end

rightscale_marker :end

