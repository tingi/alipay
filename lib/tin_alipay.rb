require 'tin_alipay/payment'
require 'tin_alipay/notify'
require 'tin_alipay/sign'
module TinAlipay
  class << self
    attr_accessor :pid
    attr_accessor :key
    attr_accessor :seller_email
  end
end
