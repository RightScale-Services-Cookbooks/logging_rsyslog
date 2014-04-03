#
# Cookbook Name:: logging_rsyslog
#

rightscale_marker :begin

log "*** in recipe: logging_rsyslog::backup_logs"

container = node[:logging_rsyslog][:backup][:container]
cloud = node[:logging_rsyslog][:backup][:storage_account_provider]

# Overrides default endpoint or for generic storage clouds such as Swift.
# Is set as ENV['STORAGE_OPTIONS'] for ros_util.
require 'json'

options =
  if node[:logging_rsyslog][:backup][:storage_account_endpoint].to_s.empty?
    {}
  else
    {'STORAGE_OPTIONS' => JSON.dump({
      :endpoint => node[:logging_rsyslog][:backup][:storage_account_endpoint],
      :cloud => node[:logging_rsyslog][:backup][:storage_account_provider].to_sym
    })}
  end

environment_variables = {
  'STORAGE_ACCOUNT_ID' => node[:logging_rsyslog][:backup][:storage_account_id],
  'STORAGE_ACCOUNT_SECRET' => node[:logging_rsyslog][:backup][:storage_account_secret]
}.merge(options)

paths=`cd #{node[:logging_rsyslog][:logs_location]}; ls */*/*/* | grep '\.zip$'`.split(/\n/)

paths.each { |path|
  bash "*** Uploading '#{path}' to '#{cloud}' container '#{container}/syslog-backups/'" do
    flags "-ex"
    user "root"
    cwd node[:logging_rsyslog][:logs_location]
    environment environment_variables
    code <<-EOH
      /opt/rightscale/sandbox/bin/ros_util put --container #{container} --cloud #{cloud} --source #{path} --dest "syslog-backups/#{path}"
    EOH
  end

  zip_folder=File.expand_path("..", "#{node[:logging_rsyslog][:logs_location]}/#{path}")
  zip_file=File.basename("#{node[:logging_rsyslog][:logs_location]}/#{path}")

  `echo "*** Uploaded '#{zip_file}' to Remote Object Storage: '#{container}/syslog-backups/#{path}'" >> #{zip_folder}/uploaded.txt`

  # Delete the local file now
  file "#{node[:logging_rsyslog][:logs_location]}/#{path}" do
    backup false
    action :delete
  end
 }

rightscale_marker :end
