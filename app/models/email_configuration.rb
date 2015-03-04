# EmailConfiguration model class
class EmailConfiguration < ActiveRecord::Base
  include Redmine::SafeAttributes
  include EmailTests
  include EmailFetches

  unloadable

  belongs_to :project
  belongs_to :tracker

  validates :host, presence: true
  validates :port, presence: true
  validates :unknown_user, presence: true
  validates :username, presence: true
  validates :password, presence: true
  validates :folder, presence: true

  validates :project, presence: true
  validates :tracker, presence: true

  validates :folder,
            presence: true,
            uniqueness: { scope: [:host, :port, :username], message: l(:msg_unique_key_folder) }

  attr_accessible :configuration_type,
                  :host, :port, :ssl,
                  :username, :password, :folder,
                  :move_on_failure, :move_on_success, :delete_unprocessed, :apop,
                  :unknown_user, :no_account_notice, :no_permission_check, :default_group,
                  :project_id, :tracker_id, :category, :issue_priority,
                  :allow_override,
                  :last_fetch_at, :flg_active

  # SCOPES
  scope :active, -> { where(flg_active: true) }

  # Static  function to fetch all the emails from active email configurations
  def self.fetch_all_emails
    configurations = EmailConfiguration.active

    configurations.each do |email_config|
      test_success, _message = email_config.test_and_fetch_emails

      if test_success
        Rails.logger.info "SUCCESS : #{log_msg(email_config)}"
      else
        Rails.logger.error "ERROR : #{log_msg(email_config)}"
      end
    end
  end

  def log_msg(email_config)
    msg = "Fetched '#{email_config.configuration_type.upcase}' account '#{email_config.username}' "\
      "(folder '#{email_config.folder}') at '#{email_config.host}':'#{email_config.port}'"

    msg
  end
end
