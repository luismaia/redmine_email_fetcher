# EmailTests model class
module EmailTests
  require 'timeout'
  require 'net/imap'
  require 'net/pop'

  def test
    if configuration_type == 'imap'
      return test_imap
    elsif configuration_type == 'pop3'
      return test_pop3
    else
      return test_failure(l(:msg_configuration_type_error))
    end
  end

  protected

  def test_imap
    begin
      imap = Timeout.timeout(10) do
        Net::IMAP.new(host, port, ssl)
      end

    rescue Errno::ECONNREFUSED, # connection refused by host or an intervening firewall.
           Errno::ETIMEDOUT, # connection timed out (possibly due to packets being dropped by an intervening firewall).
           Errno::ENETUNREACH, # there is no route to that network.
           SocketError, # hostname not known or other socket error.
           Net::IMAP::ByeResponseError, # we connected to the host, but they immediately said goodbye to us.
           Timeout::Error => e

      return test_failure(l(:msg_can_not_connect), e)
    end

    begin
      imap.login(username, password)

    rescue Net::IMAP::NoResponseError => e
      begin
        imap.disconnect
      end
      return test_failure(l(:msg_login_pass_incorrect), e)
    end

    begin
      # A Net::IMAP::NoResponseError is raised if the mailbox does not exist or is for some reason non-examinable
      imap.select(folder)
      imap.logout
      return test_success

    rescue Net::IMAP::NoResponseError => e
      imap.logout
      imap.disconnect
      return test_failure(l(:msg_can_not_select_folder), e)
    end
  end

  def test_pop3
    Timeout.timeout(10) do
      Net::POP3.enable_ssl(OpenSSL::SSL::VERIFY_NONE) if self.ssl?

      pop = Net::POP3.APOP(apop).new(host, port)
      pop.start(username, password)

      pop.started?
      pop.finish
      return test_success
    end

  rescue Errno::ECONNREFUSED, # connection refused by host or an intervening firewall.
         Errno::ETIMEDOUT, # connection timed out (possibly due to packets being dropped by an intervening firewall).
         Errno::ENETUNREACH, # there is no route to that network.
         SocketError, # hostname not known or other socket error.
         OpenSSL::SSL::SSLError,
         Timeout::Error => e
    return test_failure(l(:msg_can_not_connect), e)

  rescue Net::POPAuthenticationError => e
    return test_failure(l(:msg_login_pass_incorrect), e)
  end

  def test_success(message = l(:msg_test_success))
    [true, message]
  end

  def test_failure(message, exception = nil)
    [false, get_exception_msg(message, exception)]
  end

  def get_exception_msg(message, exception)
    if exception.nil?
      message
    else
      "#{message} : (#{exception.message})"
    end
  end
end
