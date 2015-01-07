require 'test_helper'

class TinAlipay::SignTest < ActiveSupport::TestCase
  def setup
    @params = {
      :service => 'tin_test',
      :partner => '123'
    }
    @sign = Digest::MD5.hexdigest("partner=123&service=tin_test#{TinAlipay.key}")

    @params_mobile = {
      :v => '1.0',
      :sec_id => 'MD5',
      :service => 'tin_test',
      :notify_data => 'notify_data'
    }
    @sign_mobile = Digest::MD5.hexdigest("service=tin_test&v=1.0&sec_id=MD5&notify_data=notify_data#{TinAlipay.key}")
  end

  def test_excute_md5_sign
    assert_equal @sign, TinAlipay::Sign.excute_md5(@params)
  end

  def test_verify_sign
    assert TinAlipay::Sign.verify?(@params.merge(:sign => @sign))
  end

  def test_verify_sign_when_fails
    assert_not TinAlipay::Sign.verify?(@params.merge(:danger => 'danger', :sign => @sign))
  end

  def test_verify_sign_mobile
    assert_not TinAlipay::Sign::Mobile.verify?(@params_mobile.merge(:sign => @sign_mobile, :whatever => 'x',:danger => 'danger'))
  end

  def test_verify_sign_mobile
    assert TinAlipay::Sign::Mobile.verify?(@params_mobile.merge(:sign => @sign_mobile, :whatever => 'x'))
  end

end