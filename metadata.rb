maintainer       "RightScale, Inc."
maintainer_email "support@rightscale.com"
license          "Copyright RightScale, Inc. All rights reserved."
description      "Provides 'rsyslog' implementation of the 'logging' resource" +
                 " to configure 'rsyslog' to log to a remote server or use" +
                 " default local file logging."
long_description IO.read(File.join(File.dirname(__FILE__), 'README.md'))
version          "13.50.0"

supports "centos"
supports "redhat"
supports "ubuntu"

depends "logging"

recipe "logging_rsyslog::setup_server",
  "Sets rsyslog logging provider"

recipe "logging_rsyslog::add_custom_templates",
  "Add rsyslog templates to store the messages in a human friendly folder structure (year/month/day/hostname/*)"

recipe "logging_rsyslog::add_compress_logs_cronjob",
  "Add cronjob to compress files older than a day"

attribute "logging_rsyslog/allowed_senders",
  :display_name => "Allowed rsyslog senders",
  :description =>  "TODO",
  :required => "optional",
  :recipes => [ "logging_rsyslog::add_custom_templates" ]
                                          ]
