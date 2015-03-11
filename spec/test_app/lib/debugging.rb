module ::Debugging
  def self.with_pry_remote(timeout=5.minutes)
    return unless block_given?
    begin
      yield
    rescue StandardError, MiniTest::Assertion, Exception, RuntimeError => e
      begin
        Debugging::send_developer_im('chauboldt@bender.lnstar.com', "Error running test - #{e.message}: #{e.backtrace.join("\n")[0..80]} on #{`hostname`.strip} from #{`pwd`}")
        Timeout::timeout(timeout) do
          binding.pry_remote
        end
      rescue Exception, StandardError, RuntimeError => te
        Rails.logger.warn "Uncaught/Unpried exception: #{te.message} #{te.backtrace.join("\n")}"
        raise e
      end
    end
  end

  def self.send_developer_im(recipient='chauboldt@bender.lnstar.com', message)
    # include Jabber # Makes using it a bit easier as we don't need to prepend Jabber:: to everything
    # def send_xmpp_message(recipient, message)
    # (recipient,message) = ARGV

    #Account info
    account = 'nagios@bender.lnstar.com'
    password = '10dole01'


    # Jabber::debug = true # Uncomment this if you want to see what's being sent and received!
    jid = Jabber::JID::new(account)
    client = Jabber::Client::new(jid)
    client.connect
    client.auth(password)
    client.send(Jabber::Message::new(recipient,message))
    # end
  end

  def self.wait_until(timeout=nil, log=false)
    timeout ||= ((Capybara.default_wait_time + 3) rescue 10.seconds)
    require "timeout"
    Timeout.timeout(timeout) do
      Rails.logger.warn "Waiting for something.. timeout: #{timeout}" if log
      sleep(0.1) until value = yield
      value
    end
  end

  def self.wait_until_success(timeout=nil, log=false)
    timeout ||= ((Capybara.default_wait_time + 3) rescue 10.seconds)
    wait_until(timeout) do
      begin
        Rails.logger.warn "Waiting for something.. trying: #{Kernel.caller[0..5].join("\n")}" if log
        yield
        true
      rescue => e
        Rails.logger.warn "Waiting for something.. failure: #{e.message} #{e.backtrace.join}"
        false
      end
    end
  end
end
