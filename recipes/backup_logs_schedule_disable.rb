rightscale_marker :begin

cron "rs_syslog_backup" do
  minute "15"
  hour "0"
  command "rs_run_recipe --name 'logging_rsyslog::backup_logs' 2>&1 >> /var/log/rs_backup.log"
  action :delete
end

rightscale_marker :end
