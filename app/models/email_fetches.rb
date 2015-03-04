# EmailFetches model class
module EmailFetches
  def test_and_fetch_emails
    test_success, message = test

    if test_success
      fetch_success = fetch_emails
    else
      fetch_success = false
    end

    message = l(:msg_fetch_success) if fetch_success

    [fetch_success, message]
  end

  def fetch_emails
    ### Available General (IMAP + POP3) options:
    # host=HOST                IMAP server host
    # port=PORT                IMAP server port
    # ssl=SSL                  Use SSL?
    # username=USERNAME        IMAP account
    # password=PASSWORD        IMAP password
    # folder=FOLDER            IMAP folder to read
    #
    ### Available IMAP specific options (Processed emails control options):
    # move_on_success=MAILBOX  move emails that were successfully received to MAILBOX instead of deleting them
    # move_on_failure=MAILBOX  move emails that were ignored to MAILBOX
    #
    ### Available POP3 specific options:
    # apop=1                   use APOP authentication [POP3 ONLY]
    # delete_unprocessed=1     delete messages that could not be processed successfully from the server (default
    #                          behaviour is to leave them on the server) [POP3 ONLY]
    #
    email_options = {
      host: host,
      port: port,
      ssl: (ssl ? '1' : nil),
      username: username,
      password: password,
      folder: nil,

      move_on_success: nil,
      move_on_failure: nil,
      apop: apop,
      delete_unprocessed: delete_unprocessed
    }
    email_options[:folder] = folder unless folder.blank?
    email_options[:move_on_success] = move_on_success unless move_on_success.blank?
    email_options[:move_on_failure] = move_on_failure unless move_on_failure.blank?

    ### Issue attributes control options:
    # project=PROJECT          identifier of the target project
    # status=STATUS            name of the target status
    # tracker=TRACKER          name of the target tracker
    # category=CATEGORY        name of the target category
    # priority=PRIORITY        name of the target priority
    # allow_override=ATTRS     allow email content to override attributes specified by previous options
    #                          ATTRS is a comma separated list of attributes
    #
    ### General options:
    # unknown_user=ACTION      how to handle emails from an unknown user ACTION can be one of the following values:
    #                            1) ignore: email is ignored (default)
    #                            2) accept: accept as anonymous user
    #                            3) create: create a user account
    # no_permission_check=1    disable permission checking when receiving the email
    # no_account_notice=1      disable new user account notification
    # default_group=foo,bar    adds created user to foo and bar groups
    #
    redmine_options = {
      'project' => project.identifier,
      'status' => IssueStatus.where(is_default: true).first.name,
      'tracker' => tracker.name,
      'category' => category,
      'priority' => priority,
      'allow_override' => nil,

      'unknown_user' => unknown_user,
      'no_permission_check' => (no_permission_check ? '1' : '0'),
      'no_account_notice' => (no_account_notice ? '1' : '0'),
      'default_group' => nil
    }
    redmine_options['allow_override'] = allow_override unless allow_override.blank?
    redmine_options['default_group'] = default_group unless default_group.blank?

    # Execute Redmine functions and return
    if configuration_type == 'imap'
      Redmine::IMAP.check(email_options, MailHandler.extract_options_from_env(redmine_options))
      self.update_attributes!(last_fetch_at: Time.now)
      return true
    elsif configuration_type == 'pop3'
      Redmine::POP3.check(email_options, MailHandler.extract_options_from_env(redmine_options))
      self.update_attributes!(last_fetch_at: Time.now)
      return true
    else
      return false
    end
  end
end
