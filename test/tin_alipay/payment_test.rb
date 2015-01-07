require 'test_helper'

class TinAlipay::PaymentTest < ActiveSupport::TestCase

  def test_create_direct_pay_pc_url
    options = {
      :out_trade_no      => '1',
      :subject           => 'test',
      :price             => '0.01',
      :quantity          => 1,
      :return_url        => 'return_url', 
	    :notify_url        => 'notify_url'  
    }
    assert_not_nil TinAlipay::Payment.create_direct_pay_pc_url(options)
  end
 
  def  test_create_direct_pay_mobile_url
    token = 'REQUEST_TOKEN'
    FakeWeb.register_uri(
      :get,%r|https://wappaygw\.alipay\.com/service/rest\.htm.*|,
      :body=>"res_data=<request_token>#{token}</request_token>"
    )
  	options={
  		:req_data => {
        :out_trade_no  => '1',
        :subject       => 'subject',
        :total_fee     => '0.01',
        :notify_url    => "notify_url",
        :call_back_url => 'http://www.yoursite.com/call_back'
        }}
    assert_equal token,TinAlipay::Payment.mobile_request_token(options)
    assert_not_nil  TinAlipay::Payment.create_direct_pay_mobile_url(options)
  end

end
