name             'logging_rsyslog'
maintainer       "RightScale, Inc."
maintainer_email "support@rightscale.com"
license          "Copyright RightScale, Inc. All rights reserved."
description      "Provides 'rsyslog' implementation of the 'logging' resource" +
                 " to configure 'rsyslog' to log to a remote server or use" +
                 " default local file logging."
long_description IO.read(File.join(File.dirname(__FILE__), 'README.md'))
version          "13.50.5"

supports "centos"
supports "redhat"
supports "ubuntu"

depends "logging"

recipe "logging_rsyslog::setup_server",
  "Sets rsyslog logging provider"

recipe "logging_rsyslog::add_custom_templates",
  "Add rsyslog templates to store the messages in a human friendly folder structure (year/month/day/hostname/*)"

recipe "logging_rsyslog::zip_logs_schedule_enable",
  "Creates a cronjob to compress logs at 00:15am"
  
recipe "logging_rsyslog::backup_logs",
  "Uploads the zipped logs to Remote Object Storage"
  
recipe "logging_rsyslog::backup_logs_schedule_enable",
  "Creates a cronjob to run the 'logging_rsyslog::backup_logs' recipe at 00:45am"
  
recipe "logging_rsyslog::backup_logs_schedule_disable",
  "Removes the daily backup_logs schedule"

attribute "logging_rsyslog",
  :display_name => "Rsyslog attributes",
  :type => "hash"

attribute "logging_rsyslog/allowed_senders",
  :display_name => "Allowed Rsyslog Senders",
  :description =>  "Leave this input undefined to allow any IP. Otherwise, specify a comma-separated list of IPs or CIDR ranges to accept syslog messages from. Ex: 10.0.0.0/8, 141.53.62.158",
  :required => "optional",
  :recipes => [ "logging_rsyslog::add_custom_templates" ]

attribute "logging_rsyslog/logs_location",
  :display_name => "Rsyslog Logs Path",
  :description =>  "Absolute path where the logs will be stored. Ex: /mnt/ephemeral/syslog",
  :required => "optional",
  :default => "/mnt/ephemeral/syslog",
  :recipes => [ "logging_rsyslog::add_custom_templates", "logging_rsyslog::zip_logs_schedule_enable", "logging_rsyslog::backup_logs" ]

# == Backup attributes
#
attribute "logging_rsyslog/backup",
  :display_name => "Backup settings for rsyslog backups.",
  :type => "hash"

attribute "logging_rsyslog/backup/storage_account_provider",
  :display_name => "Rsyslog Backup Storage Account Provider",
  :description =>
    "Location where the backup files will be saved." +
    " Used by backup recipe to back up to Remote Object Storage" +
    " (complete list of supported storage locations is in input dropdown)." +
    " Example: s3",
  :required => "required",
  :choice => [
    "s3",
    "Cloud_Files",
    "Cloud_Files_UK",
    "google",
    "azure",
    "swift",
    "SoftLayer_Dallas",
    "SoftLayer_Singapore",
    "SoftLayer_Amsterdam"
  ],
  :recipes => [
    "logging_rsyslog::backup_logs",
    "logging_rsyslog::backup_logs_schedule_enable"
  ]

attribute "logging_rsyslog/backup/storage_account_id",
  :display_name => "Rsyslog Backup Storage Account ID",
  :description =>
    "In order to write the backup files to the specified cloud storage location," +
    " you need to provide cloud authentication credentials." +
    " For Amazon S3, use your Amazon access key ID" +
    " (e.g., cred:AWS_ACCESS_KEY_ID). For Rackspace Cloud Files, use your" +
    " Rackspace login username (e.g., cred:RACKSPACE_USERNAME)." +
    " For OpenStack Swift the format is: 'tenantID:username'." +
    " Example: cred:AWS_ACCESS_KEY_ID",
  :required => "required",
  :recipes => [
    "logging_rsyslog::backup_logs",
    "logging_rsyslog::backup_logs_schedule_enable"
  ]

attribute "logging_rsyslog/backup/storage_account_secret",
  :display_name => "Rsyslog Backup Storage Account Secret",
  :description =>
    "In order to write the backup files to the specified cloud storage location," +
    " you need to provide cloud authentication credentials." +
    " For Amazon S3, use your AWS secret access key" +
    " (e.g., cred:AWS_SECRET_ACCESS_KEY)." +
    " For Rackspace Cloud Files, use your Rackspace account API key" +
    " (e.g., cred:RACKSPACE_AUTH_KEY). Example: cred:AWS_SECRET_ACCESS_KEY",
  :required => "required",
  :recipes => [
    "logging_rsyslog::backup_logs",
    "logging_rsyslog::backup_logs_schedule_enable"
  ]

attribute "logging_rsyslog/backup/storage_account_endpoint",
  :display_name => "Rsyslog Backup Storage Endpoint URL",
  :description =>
    "The endpoint URL for the storage cloud. This is used to override the" +
    " default endpoint or for generic storage clouds such as Swift." +
    " Example: http://endpoint_ip:5000/v2.0/tokens",
  :required => "optional",
  :default => "",
  :recipes => [
    "logging_rsyslog::backup_logs",
    "logging_rsyslog::backup_logs_schedule_enable"
  ]

attribute "logging_rsyslog/backup/container",
  :display_name => "Rsyslog Backup Container",
  :description =>
    "The cloud storage location where the backup files will be saved to." +
    " For Amazon S3, use the bucket name." +
    " For Rackspace Cloud Files, use the container name." +
    " Example: syslog-backups",
  :required => "required",
  :recipes => [
    "logging_rsyslog::backup_logs",
    "logging_rsyslog::backup_logs_schedule_enable"
  ]
