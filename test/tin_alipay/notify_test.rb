require 'test_helper'

class TinAlipay::NotifyTest < ActiveSupport::TestCase
  def setup
    @options = {:notify_id => '1234'}
    @sign_options = @options.merge(:sign_type => 'MD5', :sign => TinAlipay::Sign.excute_md5(@options))

    @notify_id = 'notify_id_test'
    @notify_params = {
      :service => 'alipay.wap.trade.create.direct',
      :v => '1.0',
      :sec_id => 'MD5',
      :notify_data => "<notify><notify_id>#{@notify_id}</notify_id><other_key>other_value</other_key></notify>"
    }
    query = [ :service, :v, :sec_id, :notify_data ].map {|key| "#{key}=#{@notify_params[key]}"}.join('&')
    @sign_params = @notify_params.merge(:sign => Digest::MD5.hexdigest("#{query}#{TinAlipay.key}"))
  end

  def test_verify_notify_pc_when_unsign
    FakeWeb.register_uri(:get, "https://mapi.alipay.com/gateway.do?service=notify_verify&partner=#{TinAlipay.pid}&notify_id=1234", :body => "true")
    assert_not TinAlipay::Notify.verify?(@options)
  end

  def test_verify_notify_pc_when_false
    FakeWeb.register_uri(:get, "https://mapi.alipay.com/gateway.do?service=notify_verify&partner=#{TinAlipay.pid}&notify_id=1234", :body => "false")
    assert_not TinAlipay::Notify.verify?(@sign_options)
  end

  def test_verify_notify_pc_when_true
    FakeWeb.register_uri(:get, "https://mapi.alipay.com/gateway.do?service=notify_verify&partner=#{TinAlipay.pid}&notify_id=1234", :body => "true")
    assert TinAlipay::Notify.verify?(@sign_options)
  end



  def test_verify_notify_mobile_when_unsign
    FakeWeb.register_uri(:get, "https://mapi.alipay.com/gateway.do?service=notify_verify&partner=#{TinAlipay.pid}&notify_id=#{@notify_id}", :body => "true")
    assert_not TinAlipay::Notify::Mobile.verify?(@notify_params)
  end

  def test_verify_notify_mobile_when_false
    FakeWeb.register_uri(:get, "https://mapi.alipay.com/gateway.do?service=notify_verify&partner=#{TinAlipay.pid}&notify_id=#{@notify_id}", :body => "false")
    assert_not TinAlipay::Notify::Mobile.verify?(@sign_params)
  end

  def test_verify_notify_mobile_when_true
    FakeWeb.register_uri(:get, "https://mapi.alipay.com/gateway.do?service=notify_verify&partner=#{TinAlipay.pid}&notify_id=#{@notify_id}", :body => "true")
    assert TinAlipay::Notify::Mobile.verify?(@sign_params)
  end



end