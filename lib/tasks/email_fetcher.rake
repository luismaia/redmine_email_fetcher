namespace :redmine do
  namespace :plugins do
    namespace :email_fetcher do

      desc <<-END_DESC
Fetch emails from all ACTIVE configured email accounts.

Examples:
  # No need to specify anything because all necessary fields are stored in the database.
  # See functionality under: Administration > Receiving emails configurations
  #
  rake redmine:plugins:email_fetcher:fetch_all_emails RAILS_ENV=production
      END_DESC
      task fetch_all_emails: :environment do |t, args|
        EmailConfiguration.fetch_all_emails
      end

    end
  end
end