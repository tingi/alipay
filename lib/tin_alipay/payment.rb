require 'open-uri'
module TinAlipay
  module Payment
    GATEWAY_PC_URL = 'https://mapi.alipay.com/gateway.do'
    OPTIONS_PC_KEYS = %w( service partner _input_charset out_trade_no subject payment_type logistics_type logistics_fee logistics_payment seller_email price quantity )
    GATEWAY_MOBILE_URL = 'https://wappaygw.alipay.com/service/rest.htm'
    OPTIONS_MOBILE_KEYS = %w( subject out_trade_no total_fee seller_account_name call_back_url )
    REQUIRED_MOBILE_KEYS = %w( service format v partner req_id req_data )
    EXECUTE_MOBILE_KEYS = %w( service format v partner )

    def self.create_direct_pay_pc_url(options = {})
      options = {
        'service'        => 'trade_create_by_buyer',
        '_input_charset' => 'utf-8',
        'partner'        => TinAlipay.pid,
        'seller_email'   => TinAlipay.seller_email,
        'payment_type'   => '1',
        'logistics_type'    => 'DIRECT',
        'logistics_fee'     => '0',
        'logistics_payment' => 'SELLER_PAY',
        'quantity'          => 1,
        'discount'          => '0'
      }.merge(new_hash(options))
      check_options_keys(options, OPTIONS_PC_KEYS)
      "#{GATEWAY_PC_URL}?#{params_pc_str(options)}"
    end

    def self.create_direct_pay_mobile_url(options)
      token=mobile_request_token(options)
      auth_and_execute(:request_token=>token)
    end

    def self.mobile_request_token(options)
      options = new_hash(options)
      data_options = {'seller_account_name' => TinAlipay.seller_email}.merge(
                           new_hash(options.delete('req_data')))
      check_options_keys(data_options, OPTIONS_MOBILE_KEYS)
      xml = data_options.map {|k, v| "<#{k}>#{v}</#{k}>" }.join
      data_xml = "<direct_trade_create_req>#{xml}</direct_trade_create_req>"
      options = {
        'service'  => 'alipay.wap.trade.create.direct',
        'req_data' => data_xml,
        'partner'  => TinAlipay.pid,
        'req_id'   => Time.now.strftime('%Y%m%d%H%M%s'),
        'format'   => 'xml',
        'v'        => '2.0'
      }.merge(options)
      check_options_keys(options, REQUIRED_MOBILE_KEYS)
      xml = open("#{GATEWAY_MOBILE_URL}?#{params_mobile_str(options)}").read
      URI::unescape(xml).scan(/\<request_token\>(.*)\<\/request_token\>/).flatten.first
    end

    def self.auth_and_execute(options)
      options = new_hash(options)
      check_options_keys(options, ['request_token'])
      req_data_xml = "<auth_and_execute_req><request_token>#{options.delete('request_token')}</request_token></auth_and_execute_req>"
      options = {
        'service'  => 'alipay.wap.auth.authAndExecute',
        'req_data' => req_data_xml,
        'partner'  => TinAlipay.pid,
        'format'   => 'xml',
        'v'        => '2.0'
      }.merge(options)
      check_options_keys(options, EXECUTE_MOBILE_KEYS)
      "#{GATEWAY_MOBILE_URL}?#{params_mobile_str(options)}"
    end

    def self.new_hash(hash)
      new_hash = {}
      hash.each do |k, v|
        new_hash[(k.to_s rescue k) || k] = v
      end
      new_hash
    end

    def self.params_pc_str(options)
      options.merge(:sign_type => 'MD5', :sign => TinAlipay::Sign.excute_md5(options)).map do |k, v|
        "#{URI::escape(k.to_s)}=#{URI::escape(v.to_s)}"
      end.join('&')
    end

    def self.check_options_keys(options, keys)
      keys.each do |key|
       warn("TinAlipay Warnning: missing required option key!: #{key}") unless options.has_key?(key)
      end
    end

    def self.params_mobile_str(options)
      options.merge!('sec_id' => 'MD5')
      options.merge('sign' => TinAlipay::Sign.excute_md5(options)).map do |key, value|
        "#{URI::escape(key.to_s)}=#{URI::escape(value.to_s)}"
      end.join('&')
    end
   
  end
end
