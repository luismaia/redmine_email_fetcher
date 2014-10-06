require 'redmine'
require 'email_configurations_hooks'

Redmine::Plugin.register :redmine_email_fetcher do
  name 'Redmine Email Fetcher plugin'
  author 'Luis Maia'
  description 'This plugin allow us to configure several IMAP and POP3 email accounts from where emails can be fetch to Redmine'
  version '0.0.1'
  url 'https://github.com/luismaia/redmine_email_fetcher'
  author_url 'https://github.com/luismaia'

  menu :admin_menu, :email_configurations, {controller: 'email_configurations', action: 'index'}, caption: :title_email_configurations
end
