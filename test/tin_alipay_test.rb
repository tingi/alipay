require 'test_helper'
require 'fakeweb'

class TinAlipayTest < ActiveSupport::TestCase
  TinAlipay.pid = 'alipay_pid'
  TinAlipay.key = 'alipay_key'
  TinAlipay.seller_email = '107191613@qq.com'

  test "truth" do
    assert_kind_of Module, TinAlipay
  end
end
