require File.expand_path('../../test_helper', __FILE__)

# EmailConfiguration Test class
class EmailConfigurationTest < ActiveSupport::TestCase
  fixtures :projects, :trackers,
           :email_configurations

  def setup
    @project = Project.find(1)
    @tracker = Tracker.find(1)

    @email_configurations = EmailConfiguration.all
    @email_configuration = EmailConfiguration.find(1)
  end

  def test_email_configuration_setup
    assert_kind_of EmailConfiguration, @email_configuration
    assert_equal @email_configuration.id, 1
  end

  def test_create_dummy_email_configuration
    email_config = email_configuration('luis.maia.01@example.com')
    assert_equal true, email_config.save
  end

  def test_validate_mandatory_fields
    # validates :configuration_type, presence: true
    email_config = email_configuration
    email_config.configuration_type = ''
    assert_equal false, email_config.save

    # validates :host, presence: true
    email_config = email_configuration
    email_config.host = ''
    assert_equal false, email_config.save

    # validates :port, presence: true
    email_config = email_configuration
    email_config.port = ''
    assert_equal false, email_config.save

    # validates :ssl, presence: true
    email_config = email_configuration
    email_config.ssl = nil
    assert_equal false, email_config.save

    # validates :username, presence: true
    email_config = email_configuration
    email_config.username = ''
    assert_equal false, email_config.save

    # validates :password, presence: true
    email_config = email_configuration
    email_config.username = ''
    assert_equal false, email_config.save

    # validates :folder, presence: true
    email_config = email_configuration
    email_config.username = ''
    assert_equal false, email_config.save

    # validates :unknown_user, presence: true
    email_config = email_configuration
    email_config.unknown_user = ''
    assert_equal false, email_config.save

    # validates :project, presence: true
    email_config = email_configuration
    email_config.project = nil
    assert_equal false, email_config.save

    # validates :tracker, presence: true
    email_config = email_configuration
    email_config.tracker = nil
    assert_equal false, email_config.save

    # validates :delete_unprocessed, inclusion: { in: [true, false] }
    email_config = email_configuration
    email_config.delete_unprocessed = nil
    assert_equal false, email_config.save

    # validates :apop, inclusion: { in: [true, false] }
    email_config = email_configuration
    email_config.apop = nil
    assert_equal false, email_config.save

    # validates :no_permission_check, inclusion: { in: [true, false] }
    email_config = email_configuration
    email_config.no_permission_check = nil
    assert_equal false, email_config.save

    # validates :no_account_notice, inclusion: { in: [true, false] }
    email_config = email_configuration
    email_config.no_account_notice = nil
    assert_equal false, email_config.save
  end

  def test_validate_optional_fields
    email_config = email_configuration('luis.maia.02@example.com')

    email_config.category = nil
    email_config.move_on_success = nil
    email_config.move_on_failure = nil
    email_config.default_group = nil
    email_config.flg_active = nil
    email_config.allow_override = nil

    assert_equal true, email_config.save
  end

  def test_email_config_flg_active
    assert_equal 2, EmailConfiguration.all.count
    assert_equal 2, EmailConfiguration.active.count

    email_config = email_configuration('luis.maia.03@example.com')
    assert_equal true, email_config.save
    assert_equal 3, EmailConfiguration.all.count
    assert_equal 3, EmailConfiguration.active.count

    email_config.update_attributes(flg_active: false)
    assert_equal 3, EmailConfiguration.all.count
    assert_equal 2, EmailConfiguration.active.count
  end

  def test_fetch_all_emails_error
    #
    # Fetch 2 email configurations
    result_out = []

    EmailConfiguration.active.each do |email_config|
      result_out << "ERROR : #{email_config.log_msg}"
    end

    assert_equal 2, EmailConfiguration.all.count
    assert_equal 2, EmailConfiguration.active.count
    assert_equal result_out, EmailConfiguration.fetch_all_emails

    #
    # Fetch 1 email configuration
    EmailConfiguration.active.each do |email_config|
      email_config.update_attributes(flg_active: false)
    end

    new_email_config = email_configuration('luis.maia.04@example.com')
    assert_equal true, new_email_config.save

    assert_equal 3, EmailConfiguration.all.count
    assert_equal 1, EmailConfiguration.active.count

    assert_equal ["ERROR : #{new_email_config.log_msg}"], EmailConfiguration.fetch_all_emails

    #
    # Not using IMAP or POP3
    new_email_config.update_attributes(configuration_type: 'OTHER_STUFF')

    assert_equal 3, EmailConfiguration.all.count
    assert_equal 1, EmailConfiguration.active.count

    assert_equal ["ERROR : #{new_email_config.log_msg}"], EmailConfiguration.fetch_all_emails
  end

  #
  # !!! To test this method successfully, it's necessary to configure it properly !!!
  #
  def test_fetch_all_emails_imap
    #
    # Fetch 1 email configuration (USING IMAP)
    EmailConfiguration.active.each do |email_config|
      email_config.update_attributes(flg_active: false)
    end

    real_email_config_imap = EmailConfiguration.new(configuration_type: 'imap',
                                                    host: '',
                                                    port: '993',
                                                    ssl: true,
                                                    username: '',
                                                    password: '',
                                                    folder: 'INBOX',
                                                    project_id: @project.id,
                                                    tracker_id: @tracker.id)
    assert_equal true, real_email_config_imap.save

    assert_equal 3, EmailConfiguration.all.count
    assert_equal 1, EmailConfiguration.active.count

    assert_equal ["SUCCESS : #{real_email_config_imap.log_msg}"], EmailConfiguration.fetch_all_emails

    real_email_config_imap.update_attributes(folder: '!!NON-EXISTENT-FOLDER!!')
    assert_equal ["ERROR : #{real_email_config_imap.log_msg}"], EmailConfiguration.fetch_all_emails

    real_email_config_imap.update_attributes(folder: 'INBOX', password: 'wrong_password')
    assert_equal ["ERROR : #{real_email_config_imap.log_msg}"], EmailConfiguration.fetch_all_emails
  end

  #
  # !!! To test this method successfully, it's necessary to configure it properly !!!
  #
  def test_fetch_all_emails_pop3
    #
    # Fetch 1 email configuration (USING POP3)
    EmailConfiguration.active.each do |email_config|
      email_config.update_attributes(flg_active: false)
    end

    real_email_config_pop3 = EmailConfiguration.new(configuration_type: 'pop3',
                                                    host: '',
                                                    port: '110',
                                                    ssl: false,
                                                    username: '',
                                                    password: '',
                                                    folder: 'INBOX',
                                                    apop: false,
                                                    delete_unprocessed: false,
                                                    project_id: @project.id,
                                                    tracker_id: @tracker.id)
    assert_equal true, real_email_config_pop3.save

    assert_equal 3, EmailConfiguration.all.count
    assert_equal 1, EmailConfiguration.active.count

    assert_equal ["SUCCESS : #{real_email_config_pop3.log_msg}"], EmailConfiguration.fetch_all_emails

    real_email_config_pop3.update_attributes(password: 'wrong_password')
    assert_equal ["ERROR : #{real_email_config_pop3.log_msg}"], EmailConfiguration.fetch_all_emails

    real_email_config_pop3.update_attributes(ssl: true)
    assert_equal ["ERROR : #{real_email_config_pop3.log_msg}"], EmailConfiguration.fetch_all_emails
  end

  private

  def email_configuration(email = nil)
    email = 'test_create_email_configuration@example.com' if email.nil?

    email_config = EmailConfiguration.new(folder: "INBOX_#{Time.now.to_f}",
                                          last_fetch_at: '',
                                          host: 'mail.example.com',
                                          no_permission_check: true,
                                          no_account_notice: false,
                                          unknown_user: 'accept',
                                          apop: false,
                                          category: '',
                                          move_on_success: '',
                                          ssl: false,
                                          delete_unprocessed: false,
                                          priority: nil,
                                          move_on_failure: '',
                                          project_id: @project.id,
                                          port: '993',
                                          tracker_id: @tracker.id,
                                          default_group: '',
                                          flg_active: true,
                                          configuration_type: 'imap',
                                          allow_override: '',
                                          password: 'password',
                                          username: email)

    email_config
  end
end
