require 'redmine'
require 'email_configurations_hooks'

if RUBY_VERSION < '1.9'
  ruby_version_error = '*** error redmine_email_fetcher: This plugin (redmine_email_fetcher) was not installed, '\
  'since it requires a Ruby version equal or higher than 1.9 (and your Ruby version '\
  "is #{RUBY_VERSION})"

  # Rails.logger.error ruby_version_error
  puts ruby_version_error

elsif Rails::VERSION::MAJOR < 3
  rails_version_error = '*** error redmine_email_fetcher: This plugin (redmine_email_fetcher) was not installed, '\
  'since it requires a Rails version equal or higher than 3 (and your Rails version '\
  "is #{Rails::VERSION::MAJOR})"

  # Rails.logger.error rails_version_error
  puts rails_version_error

else
  Redmine::Plugin.register :redmine_email_fetcher do
    name 'Redmine Email Fetcher plugin'
    author 'Luis Maia'
    description 'This plugin allows the configuration of several IMAP and POP3 email accounts'\
    'from where emails can be fetch into Redmine'
    version '0.0.2'
    url 'https://github.com/luismaia/redmine_email_fetcher'
    author_url 'https://github.com/luismaia'
    requires_redmine version_or_higher: '2.1.0'

    menu :admin_menu,
         :email_configurations,
         { controller: 'email_configurations', action: 'index' },
         caption: :title_email_configurations
  end

  # puts 'This plugin works with the current Ruby, Rails and Redmine versions'
end
